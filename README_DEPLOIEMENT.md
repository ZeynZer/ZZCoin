# 🚀 ZZ Coin v2 — Guide de déploiement

## ⚠️ ÉTAPE 1 — Mettre à jour Supabase (OBLIGATOIRE)

1. Va sur https://supabase.com → ton projet → **SQL Editor**
2. Si tu avais déjà des tables de la v1, **décommente** les lignes `DROP TABLE` en haut du fichier `SUPABASE_SCHEMA_V2.sql` pour repartir propre (⚠️ ça efface tout l'ancien contenu)
3. Colle tout le contenu de `SUPABASE_SCHEMA_V2.sql` et clique **Run**
4. Vérifie dans **Table Editor** : tu dois voir 4 tables → `users`, `missions`, `transactions`, `messages`
5. Vérifie dans **Database → Replication** que les 4 tables ont le Realtime activé (normalement fait automatiquement par le script)

### Compte admin
Le script crée automatiquement le compte **Zeyn** avec le mot de passe `admin123`.
**Connecte-toi avec Zeyn / admin123 puis change immédiatement le mot de passe** dans Profil → Changer le mot de passe.

## ÉTAPE 2 — Déployer sur GitHub Pages

1. Va sur ton repo GitHub `ZZCoin`
2. Supprime tous les anciens fichiers du repo
3. Upload tout le contenu du dossier `dist/` de ce zip à la racine du repo
4. Vérifie Settings → Pages → Source = branche `main`, dossier `/`
5. Attends 1-2 min, ton site est à jour sur `https://tonpseudo.github.io/ZZCoin/`

## ÉTAPE 3 — Réinstaller la PWA

Comme le code a beaucoup changé, sur ton téléphone :
1. Supprime l'ancienne icône ZZ Coin de ton écran d'accueil
2. Va sur le site dans Safari/Chrome
3. Refais "Ajouter à l'écran d'accueil"

## Nouveautés v2

✅ **Vrais comptes** avec prénom + mot de passe (pas de chiffrement, stockage simple)
✅ **Session persistante** — reste connecté jusqu'à déconnexion manuelle
✅ **Missions ouvertes à tous** — n'importe qui peut créer une mission et la financer
✅ **Historique nommé** — "100 ZZ de Inès", "50 ZZ de Asmaa" etc.
✅ **Transferts directs** entre n'importe quels utilisateurs (onglet Communauté)
✅ **Chat temps réel** — un chat général + un chat par mission
✅ **Tout en temps réel** — soldes, missions, messages se mettent à jour sans recharger
✅ **Compte Zeyn = admin** — panneau de contrôle total (gérer soldes, bannir, supprimer)
✅ **Personnalisation** — emoji + couleur au choix, modifiables à tout moment
✅ **PWA optimisée** — vibrations au toucher, notifications, animations fluides

## Structure des ZZ
- 1000 ZZ = 10€ · 100 ZZ = 1€ · 10 ZZ = 0.10€

## Notes de sécurité
Cette app n'a **aucun chiffrement** des mots de passe (stockage en clair dans Supabase) et l'accès aux données est public (pas d'authentification Supabase). C'est volontaire pour la simplicité, mais ⚠️ **n'utilise pas de mot de passe que tu utilises ailleurs**, et garde l'URL du site privée si tu veux limiter l'accès à ta communauté.
