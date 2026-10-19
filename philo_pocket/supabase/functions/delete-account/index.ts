import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.8"

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

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
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })
  if (req.method !== 'POST') return jsonResponse({ error: 'Méthode non autorisée.' }, 405)

  if (!SUPABASE_URL || !SUPABASE_ANON_KEY || !SUPABASE_SERVICE_ROLE_KEY) {
    return jsonResponse({ error: 'Service de suppression non configuré.' }, 503)
  }

  const authHeader = req.headers.get('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    return jsonResponse({ error: 'Authentification requise.' }, 401)
  }

  try {
    const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } },
      auth: { persistSession: false, autoRefreshToken: false },
    })
    const { data: userResult, error: authError } = await userClient.auth.getUser()
    if (authError || !userResult.user) {
      return jsonResponse({ error: 'Session invalide ou expirée.' }, 401)
    }

    const adminClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
      auth: { persistSession: false, autoRefreshToken: false },
    })
    const { error: applicationDeleteError } = await adminClient
      .from('teacher_applications')
      .delete()
      .eq('user_id', userResult.user.id)
    if (applicationDeleteError) {
      return jsonResponse({ error: 'Les données de candidature n’ont pas pu être supprimées.' }, 500)
    }

    const { error: deleteError } = await adminClient.auth.admin.deleteUser(userResult.user.id)
    if (deleteError) {
      return jsonResponse({ error: 'La suppression du compte a échoué.' }, 500)
    }

    return jsonResponse({ success: true }, 200)
  } catch {
    return jsonResponse({ error: 'La suppression du compte a échoué.' }, 500)
  }
})
