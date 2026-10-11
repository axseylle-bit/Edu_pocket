-- Philo Pocket: migration de sécurité à appliquer dans le SQL Editor Supabase.
-- Elle ne crée aucun abonnement et ne traite aucun paiement.

-- Les tables de données personnelles ne doivent pas être accessibles au rôle
-- anonyme. Paiements et écritures administratives restent côté serveur/Edge
-- Function avec la clé service_role, jamais dans l'APK.
ALTER TABLE public.utilisateurs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profils_eleves ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.liaisons_parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suivi_progression ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.abonnements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Les DROP rendent la migration relançable, y compris sur un projet de test.
DROP POLICY IF EXISTS "Lire son profil eleve" ON public.profils_eleves;
CREATE POLICY "Lire son profil eleve" ON public.profils_eleves
  FOR SELECT USING (auth.uid() = utilisateur_id);

DROP POLICY IF EXISTS "Lire son abonnement" ON public.abonnements;
CREATE POLICY "Lire son abonnement" ON public.abonnements
  FOR SELECT USING (auth.uid() = utilisateur_id);

DROP POLICY IF EXISTS "Lire ses liaisons parentales" ON public.liaisons_parents;
CREATE POLICY "Lire ses liaisons parentales" ON public.liaisons_parents
  FOR SELECT USING (auth.uid() = parent_id OR auth.uid() = eleve_id);

DROP POLICY IF EXISTS "Inserer sa progression" ON public.suivi_progression;
CREATE POLICY "Inserer sa progression" ON public.suivi_progression
  FOR INSERT WITH CHECK (auth.uid() = eleve_id);

DROP POLICY IF EXISTS "Mettre a jour sa progression" ON public.suivi_progression;
CREATE POLICY "Mettre a jour sa progression" ON public.suivi_progression
  FOR UPDATE USING (auth.uid() = eleve_id) WITH CHECK (auth.uid() = eleve_id);
