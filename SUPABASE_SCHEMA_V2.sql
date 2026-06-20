-- =====================================================
-- ZZ COIN v2 - Schéma Supabase complet
-- ⚠️ Ce script efface TOUTES les données existantes (users, missions, transactions, messages)
-- et repart de zéro avec le bon schéma. Le compte Zeyn (admin) est recréé à la fin.
-- Colle ce code dans l'éditeur SQL de Supabase puis clique "Run"
-- =====================================================

-- Nettoyage FORCÉ : on repart de zéro pour éviter tout conflit avec l'ancien schéma v1
-- (l'ancienne table "transactions" avait des colonnes différentes : user_id au lieu de from_user/to_user)
DROP TABLE IF EXISTS messages CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS missions CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =====================================================
-- TABLE: users
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  emoji TEXT DEFAULT '😊',
  color TEXT DEFAULT '#6C63FF',
  is_admin BOOLEAN DEFAULT FALSE,
  zz_balance INTEGER DEFAULT 0,
  bio TEXT DEFAULT '',
  banned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- TABLE: missions
-- =====================================================
CREATE TABLE IF NOT EXISTS missions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  zz_reward INTEGER NOT NULL DEFAULT 100,
  icon TEXT DEFAULT '🎯',
  deadline DATE,
  status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'claimed', 'pending_validation', 'completed', 'rejected', 'cancelled')),
  created_by UUID REFERENCES users(id) ON DELETE CASCADE,
  claimed_by UUID REFERENCES users(id) ON DELETE SET NULL,
  claimed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- TABLE: transactions (historique fiable des versements)
-- =====================================================
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  from_user UUID REFERENCES users(id) ON DELETE SET NULL,
  to_user UUID REFERENCES users(id) ON DELETE SET NULL,
  amount INTEGER NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('mission_reward', 'transfer', 'convert', 'admin_grant', 'admin_remove')),
  mission_id UUID REFERENCES missions(id) ON DELETE SET NULL,
  note TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- TABLE: messages (chat global + chat par mission)
-- =====================================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room TEXT NOT NULL DEFAULT 'global', -- 'global' ou 'mission_<uuid>'
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_messages_room ON messages(room, created_at);
CREATE INDEX IF NOT EXISTS idx_missions_status ON missions(status);
CREATE INDEX IF NOT EXISTS idx_transactions_users ON transactions(from_user, to_user);

-- =====================================================
-- ROW LEVEL SECURITY - Accès public (pas d'auth Supabase)
-- =====================================================
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_access_users" ON users;
DROP POLICY IF EXISTS "public_access_missions" ON missions;
DROP POLICY IF EXISTS "public_access_transactions" ON transactions;
DROP POLICY IF EXISTS "public_access_messages" ON messages;

CREATE POLICY "public_access_users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_access_missions" ON missions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_access_transactions" ON transactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_access_messages" ON messages FOR ALL USING (true) WITH CHECK (true);

-- =====================================================
-- REALTIME - Active la diffusion en temps réel
-- =====================================================
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE users;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE missions;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE transactions;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE messages;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- =====================================================
-- Compte admin Zeyn (créé automatiquement, mot de passe à changer après 1ère connexion)
-- =====================================================
INSERT INTO users (name, password, emoji, color, is_admin, zz_balance)
VALUES ('Zeyn', 'admin123', '👑', '#FFD700', true, 0)
ON CONFLICT (name) DO NOTHING;
