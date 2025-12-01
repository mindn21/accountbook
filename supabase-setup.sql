-- 가계부 데이터 테이블 생성
CREATE TABLE IF NOT EXISTS household_data (
  id BIGSERIAL PRIMARY KEY,
  users JSONB DEFAULT '[]'::jsonb,
  payment_methods JSONB DEFAULT '[]'::jsonb,
  assets JSONB DEFAULT '[]'::jsonb,
  categories JSONB DEFAULT '[]'::jsonb,
  transactions JSONB DEFAULT '[]'::jsonb,
  monthly_budget BIGINT DEFAULT 0,
  category_budgets JSONB DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security (RLS) 비활성화 (간단한 사용을 위해)
ALTER TABLE household_data DISABLE ROW LEVEL SECURITY;

-- 인덱스 생성 (성능 향상)
CREATE INDEX IF NOT EXISTS idx_household_updated_at ON household_data(updated_at DESC);
