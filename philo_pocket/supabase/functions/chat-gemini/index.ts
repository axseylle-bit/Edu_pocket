import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.8"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')

// Modèles autorisés pour éviter les requêtes abusives sur des modèles non prévus
const ALLOWED_MODELS = [
  'gemini-1.5-flash-latest',
  'gemini-1.5-flash',
  'gemini-1.5-pro-latest',
  'gemini-2.0-flash',
]

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Gestion de la négociation CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // 1. Contrôle d'autorisation JWT (l'utilisateur doit être authentifié)
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Accès non autorisé : En-tête d\'autorisation manquant.' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 401,
        }
      )
    }

    if (SUPABASE_URL && SUPABASE_ANON_KEY) {
      const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
        global: { headers: { Authorization: authHeader } },
      })
      const {
        data: { user },
        error: authError,
      } = await supabase.auth.getUser()

      if (authError || !user) {
        return new Response(
          JSON.stringify({
            error: 'Session invalide ou expirée. Veuillez vous reconnecter.',
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 401,
          }
        )
      }
    }

    // 2. Vérification de la clé API Gemini
    if (!GEMINI_API_KEY) {
      return new Response(
        JSON.stringify({
          error: 'Configuration serveur incomplète : GEMINI_API_KEY est manquante.',
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 500,
        }
      )
    }

    // 3. Validation et assainissement des données reçues
    const body = await req.json()
    const { contents, systemInstruction, model } = body

    if (!contents || !Array.isArray(contents) || contents.length === 0) {
      return new Response(
        JSON.stringify({
          error: 'Le paramètre "contents" doit être un tableau non vide.',
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400,
        }
      )
    }

    // Restriction stricte du modèle demandé
    const targetModel = (model && ALLOWED_MODELS.includes(model))
      ? model
      : 'gemini-1.5-flash-latest'

    // Limitation de taille pour éviter les abus de quota (max ~250 Ko)
    const payloadSize = JSON.stringify(contents).length
    if (payloadSize > 250000) {
      return new Response(
        JSON.stringify({
          error: 'Le volume du message dépasse la limite autorisée.',
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 413,
        }
      )
    }

    // Cadrage strict du rôle pédagogique
    const baseInstruction =
      "Tu es ALECKSE, professeure virtuelle de philosophie dédiée au programme officiel du Gabon (Première et Terminale). Tu refuses fermement toute demande non philosophique ou hors-sujet."
    const finalSystemInstruction = systemInstruction
      ? `${baseInstruction}\n\n${systemInstruction}`
      : baseInstruction

    // 4. Appel sécurisé vers l'API Google Gemini
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${targetModel}:generateContent?key=${GEMINI_API_KEY}`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          contents: contents,
          system_instruction: {
            parts: [{ text: finalSystemInstruction }],
          },
          generationConfig: {
            temperature: 0.7,
            maxOutputTokens: 2048,
          },
        }),
      }
    )

    const data = await response.json()

    if (!response.ok) {
      const errorMessage = data.error?.message || 'Erreur lors de l\'appel à Gemini.'
      throw new Error(errorMessage)
    }

    const reply =
      data.candidates?.[0]?.content?.parts?.[0]?.text ||
      "Désolé, je n'ai pas pu formuler de réponse pour le moment."

    return new Response(JSON.stringify({ reply }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error: any) {
    return new Response(
      JSON.stringify({
        error: error.message || 'Une erreur inattendue est survenue.',
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
