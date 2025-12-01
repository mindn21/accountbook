-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 사용자 삽입
INSERT INTO users (name) VALUES ('국환'), ('혜지')
ON CONFLICT DO NOTHING;

-- 결제수단 테이블
CREATE TABLE IF NOT EXISTS payment_methods (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  is_favorite BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 결제수단 삽입
INSERT INTO payment_methods (name, display_order, is_favorite) VALUES
  ('현금', 1, true),
  ('체크카드', 2, true),
  ('신용카드1', 3, true),
  ('신용카드2', 4, true)
ON CONFLICT DO NOTHING;

-- 자산 테이블
CREATE TABLE IF NOT EXISTS assets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  balance NUMERIC DEFAULT 0,
  display_order INTEGER DEFAULT 0,
  is_favorite BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 자산 삽입
INSERT INTO assets (name, balance, display_order, is_favorite) VALUES
  ('입출금 통장', 0, 1, true),
  ('자동차 통장', 0, 2, true),
  ('생활비 통장', 0, 3, true)
ON CONFLICT DO NOTHING;

-- 카테고리 테이블
CREATE TABLE IF NOT EXISTS categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT CHECK (type IN ('income', 'expense')),
  display_order INTEGER DEFAULT 0,
  is_favorite BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 기본 카테고리 삽입
INSERT INTO categories (name, type, display_order, is_favorite) VALUES
  ('급여', 'income', 1, true),
  ('부수입', 'income', 2, true),
  ('식비', 'expense', 1, true),
  ('카페', 'expense', 2, true),
  ('교통', 'expense', 3, true),
  ('쇼핑', 'expense', 4, true),
  ('생활', 'expense', 5, false),
  ('취미', 'expense', 6, false),
  ('의료', 'expense', 7, false),
  ('경조사', 'expense', 8, false),
  ('미용', 'expense', 9, false),
  ('기타', 'expense', 10, false)
ON CONFLICT DO NOTHING;

-- 거래 로그 테이블 (입출금, 자산이동 모두 포함)
CREATE TABLE IF NOT EXISTS transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  type TEXT CHECK (type IN ('income', 'expense', 'transfer')) NOT NULL,
  user_id UUID REFERENCES users(id),
  amount NUMERIC NOT NULL,
  category_id UUID REFERENCES categories(id),
  payment_method_id UUID REFERENCES payment_methods(id),
  asset_id UUID REFERENCES assets(id),
  to_asset_id UUID REFERENCES assets(id), -- 자산이동 시 목적지 자산
  memo TEXT,
  transaction_date DATE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);
CREATE INDEX IF NOT EXISTS idx_transactions_user ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_asset ON transactions(asset_id);
CREATE INDEX IF NOT EXISTS idx_transactions_payment_method ON transactions(payment_method_id);

-- RLS (Row Level Security) 활성화
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- 모든 사용자가 읽고 쓸 수 있도록 정책 설정 (개인용 앱이므로)
CREATE POLICY "Allow all for users" ON users FOR ALL USING (true);
CREATE POLICY "Allow all for payment_methods" ON payment_methods FOR ALL USING (true);
CREATE POLICY "Allow all for assets" ON assets FOR ALL USING (true);
CREATE POLICY "Allow all for categories" ON categories FOR ALL USING (true);
CREATE POLICY "Allow all for transactions" ON transactions FOR ALL USING (true);
