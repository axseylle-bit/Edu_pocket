import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.8"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')
const MAX_REQUEST_BYTES = 32_000
const MAX_CONTENTS = 40
const MAX_TEXT_CHARS = 24_000
const SERVER_MODEL = 'gemini-1.5-flash-latest'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

function jsonResponse(body: Record<string, unknown>, status: number) {
  return new Response(JSON.stringify(body), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status,
  })
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  if (req.method !== 'POST') {
    return jsonResponse({ error: 'Méthode non autorisée.' }, 405)
  }

  if (!SUPABASE_URL || !SUPABASE_ANON_KEY || !GEMINI_API_KEY) {
    return jsonResponse({ error: 'Service IA non configuré.' }, 503)
  }

  const authHeader = req.headers.get('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    return jsonResponse({ error: 'Authentification requise.' }, 401)
  }

  try {
    const rawBody = await req.text()
    if (new TextEncoder().encode(rawBody).byteLength > MAX_REQUEST_BYTES) {
      return jsonResponse({ error: 'La requête dépasse la taille autorisée.' }, 413)
    }

    let body: unknown
    try {
      body = JSON.parse(rawBody)
    } catch {
      return jsonResponse({ error: 'Corps JSON invalide.' }, 400)
    }

    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      return jsonResponse({ error: 'Corps de requête invalide.' }, 400)
    }

    const { contents, systemInstruction } = body as Record<string, unknown>
    if (!Array.isArray(contents) || contents.length === 0 || contents.length > MAX_CONTENTS) {
      return jsonResponse({ error: 'Historique de conversation invalide ou trop long.' }, 400)
    }

    let totalTextChars = 0
    for (const item of contents) {
      if (!item || typeof item !== 'object' || Array.isArray(item)) {
        return jsonResponse({ error: 'Message invalide.' }, 400)
      }
      const message = item as Record<string, unknown>
      if (!['user', 'model'].includes(String(message.role)) || !Array.isArray(message.parts) || message.parts.length === 0) {
        return jsonResponse({ error: 'Format de conversation invalide.' }, 400)
      }
      for (const part of message.parts) {
        if (!part || typeof part !== 'object' || typeof (part as Record<string, unknown>).text !== 'string') {
          return jsonResponse({ error: 'Seuls les messages texte sont acceptés.' }, 400)
        }
        totalTextChars += ((part as Record<string, unknown>).text as string).length
        if (totalTextChars > MAX_TEXT_CHARS) {
          return jsonResponse({ error: 'Le texte de la conversation est trop long.' }, 413)
        }
      }
    }

    if (systemInstruction !== undefined &&
        (typeof systemInstruction !== 'string' || systemInstruction.length > 8_000)) {
      return jsonResponse({ error: 'Consignes de session invalides ou trop longues.' }, 400)
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false, autoRefreshToken: false },
    })
    const { data: userResult, error: authError } = await supabase.auth.getUser()
    if (authError || !userResult.user) {
      return jsonResponse({ error: 'Session invalide ou expirée.' }, 401)
    }

    const { data: quota, error: quotaError } = await supabase.rpc('consume_daily_ai_quota')
    if (quotaError || !quota) {
      return jsonResponse({ error: 'Contrôle de quota indisponible.' }, 503)
    }
    if (quota.allowed !== true) {
      const isRateLimited = quota.reason === 'rate_limit'
      return jsonResponse({
        error: isRateLimited ? 'Patiente avant d’envoyer une nouvelle demande.' : 'Quota IA quotidien atteint.',
        reason: quota.reason,
        remaining: quota.remaining ?? 0,
      }, 429)
    }

    const baseInstruction =
      "Tu es ALECKSE, une tutrice pédagogique pour les programmes scolaires du Gabon. " +
      "Tu guides l'élève avec bienveillance, expliques les étapes et encourages son raisonnement."
    const extraInstruction = typeof systemInstruction === 'string' && systemInstruction.trim().length > 0
      ? `\n\nContexte pédagogique fourni pour cette session :\n${systemInstruction.trim()}`
      : ''

    const upstream = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${SERVER_MODEL}:generateContent?key=${GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents,
          system_instruction: { parts: [{ text: `${baseInstruction}${extraInstruction}` }] },
          generationConfig: { temperature: 0.7, maxOutputTokens: 2048 },
        }),
      },
    )

    if (!upstream.ok) {
      return jsonResponse({ error: 'Le service IA est momentanément indisponible.' }, 502)
    }

    const data = await upstream.json()
    const reply = data.candidates?.[0]?.content?.parts?.[0]?.text
    if (typeof reply !== 'string' || reply.length === 0) {
      return jsonResponse({ error: 'Aucune réponse IA exploitable.' }, 502)
    }

    return jsonResponse({ reply, remaining: quota.remaining }, 200)
  } catch {
    // Do not return upstream exception details or prompt contents to the caller.
    return jsonResponse({ error: 'Une erreur inattendue est survenue.' }, 500)
  }
})
