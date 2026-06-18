# 🚀 Déploiement ZZ Bank sur GitHub Pages

## 1. Configurer Supabase (OBLIGATOIRE en premier)

1. Va sur https://supabase.com → ton projet
2. Clique sur **SQL Editor** dans le menu gauche
3. Colle et exécute tout le contenu du fichier `SUPABASE_SCHEMA.sql`
4. Vérifie dans **Table Editor** que tu vois 3 tables : `users`, `missions`, `transactions`

## 2. Déployer sur GitHub Pages

### Option A — Le plus simple (recommandé)
1. Crée un nouveau repo sur GitHub (ex: `zz-bank`)
2. Va dans Settings → Pages → Source: **GitHub Actions**
3. Upload le contenu du dossier `dist/` directement dans la branche `main`
4. Ton site sera accessible à `https://tonpseudo.github.io/zz-bank/`

### Option B — Via Git
```bash
cd dist
git init
git add .
git commit -m "ZZ Bank v1"
git branch -M main
git remote add origin https://github.com/TONPSEUDO/zz-bank.git
git push -u origin main
```
Puis active GitHub Pages sur la branche `main`, dossier racine `/`.

## 3. Installer comme PWA

Sur iPhone : Safari → Partager → "Sur l'écran d'accueil"
Sur Android : Chrome → Menu → "Ajouter à l'écran d'accueil"

## Structure des ZZ
- 1000 ZZ = 10€
- 100 ZZ = 1€
- 10 ZZ = 0.10€
