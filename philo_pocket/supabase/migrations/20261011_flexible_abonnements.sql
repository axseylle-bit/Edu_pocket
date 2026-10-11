-- Migration : Assouplissement de la table abonnements pour supporter tous les paliers, pionniers et packages
-- Date : 11 Octobre 2026
-- Auteur : EduPocket Team

-- Suppression de la contrainte CHECK rigide sur le palier pour autoriser
-- toutes les formules actuelles (Socrate, Platon, Aristote, Archimède, Léonard de Vinci, Gustave Eiffel)
-- ainsi que les forfaits et packages (Solo, Filière Complète, Trimestre Réussite, Annuel Examen d'État).
ALTER TABLE IF EXISTS public.abonnements 
    DROP CONSTRAINT IF EXISTS abonnements_palier_check;
