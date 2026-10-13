-- ============================================================================
-- SQL statements to create constraints for the database schema
--
--   npx prisma migrate dev --name init --create-only
--
-- Append this file to the generated migration SQL file to add constraints to
-- the database schema.
--
--   npx prisma migrate dev
-- ============================================================================

-- 1. Pin each profile's account_type to the correct value
ALTER TABLE capital_humano_profiles   ADD CONSTRAINT check_type CHECK (account_type = 'CAPITAL_HUMANO');
ALTER TABLE personal_CATT_profiles    ADD CONSTRAINT check_type CHECK (account_type = 'PERSONAL_CATT');
ALTER TABLE profesor_profiles         ADD CONSTRAINT check_type CHECK (account_type = 'PROFESOR');
ALTER TABLE director_externo_profiles ADD CONSTRAINT check_type CHECK (account_type = 'DIRECTOR_EXTERNO');
ALTER TABLE alumno_profiles           ADD CONSTRAINT check_type CHECK (account_type = 'ALUMNO');

-- 2. Account type is immutable
CREATE OR REPLACE FUNCTION prevent_account_type_update() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  IF NEW.type IS DISTINCT FROM OLD.type THEN
    RAISE EXCEPTION 'accounts.type is immutable (account %)', OLD.id
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END $$;

CREATE TRIGGER accounts_type_immutable
  BEFORE UPDATE OF type ON accounts
  FOR EACH ROW EXECUTE FUNCTION prevent_account_type_update();

-- 3. Every account must have its profile
CREATE OR REPLACE FUNCTION account_has_profile(acc_id uuid, acc_type account_type)
RETURNS BOOLEAN AS $$
  SELECT CASE acc_type
    WHEN 'CAPITAL_HUMANO'   THEN EXISTS (SELECT 1 FROM capital_humano_profiles   WHERE account_id = acc_id)
    WHEN 'PERSONAL_CATT'    THEN EXISTS (SELECT 1 FROM personal_CATT_profiles    WHERE account_id = acc_id)
    WHEN 'PROFESOR'         THEN EXISTS (SELECT 1 FROM profesor_profiles         WHERE account_id = acc_id)
    WHEN 'DIRECTOR_EXTERNO' THEN EXISTS (SELECT 1 FROM director_externo_profiles WHERE account_id = acc_id)
    WHEN 'ALUMNO'           THEN EXISTS (SELECT 1 FROM alumno_profiles           WHERE account_id = acc_id)
    ELSE false
  END;
$$ LANGUAGE sql STABLE;

CREATE OR REPLACE FUNCTION assert_account_profile() RETURNS TRIGGER AS $$
DECLARE
  acc accounts%ROWTYPE;
BEGIN
  SELECT * INTO acc FROM accounts
    WHERE id = CASE WHEN TG_TABLE_NAME = 'accounts' THEN NEW.id ELSE OLD.id END;
  IF FOUND AND NOT account_has_profile(acc.id, acc.type) THEN
    RAISE EXCEPTION 'account % (type %) has no matching profile', acc.id, acc.type
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NULL;
END $$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER accounts_require_profile_trigger
  AFTER INSERT, UPDATE ON accounts DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_profile();

-- Block deleting a profile if the account still exists
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON capital_humano_profiles   DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON personal_catt_profiles    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON profesor_profiles         DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON director_externo_profiles DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON alumno_profiles           DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
