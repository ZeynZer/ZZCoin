-- =====================================================
-- ZZ BANK - Schéma Supabase
-- Colle ce code dans l'éditeur SQL de Supabase
-- =====================================================

-- Table des utilisateurs (maman + enfants)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  emoji TEXT DEFAULT '👦',
  color TEXT DEFAULT '#6C63FF',
  role TEXT NOT NULL CHECK (role IN ('mom', 'child')),
  zz_balance INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des missions
CREATE TABLE IF NOT EXISTS missions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  zz_reward INTEGER NOT NULL DEFAULT 100,
  icon TEXT DEFAULT '🎯',
  deadline DATE,
  status TEXT NOT NULL DEFAULT 'available' CHECK (status IN ('available', 'claimed', 'pending_validation', 'completed', 'rejected')),
  created_by UUID REFERENCES users(id),
  claimed_by UUID REFERENCES users(id),
  claimed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table des transactions
CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  mission_id UUID REFERENCES missions(id),
  amount INTEGER NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('earn', 'convert', 'bonus')),
  note TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Accès public en lecture/écriture (app famille sans auth)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_access_users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_access_missions" ON missions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_access_transactions" ON transactions FOR ALL USING (true) WITH CHECK (true);
