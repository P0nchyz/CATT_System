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
ALTER TABLE capital_humano_profiles   ADD CONSTRAINT capital_humano_profile_type_check   CHECK (account_type = 'CAPITAL_HUMANO');
ALTER TABLE personal_catt_profiles    ADD CONSTRAINT personal_catt_profile_type_check    CHECK (account_type = 'PERSONAL_CATT');
ALTER TABLE profesor_profiles         ADD CONSTRAINT profesor_profile_type_check         CHECK (account_type = 'PROFESOR');
ALTER TABLE director_externo_profiles ADD CONSTRAINT director_profile_externo_type_check CHECK (account_type = 'DIRECTOR_EXTERNO');
ALTER TABLE alumno_profiles           ADD CONSTRAINT alumno_profile_type_check           CHECK (account_type = 'ALUMNO');


CREATE FUNCTION assert_account_has_profile() RETURNS trigger
LANGUAGE plpgsql AS $$
DECLARE
  acc_id   uuid;
  acc_role account_role;
  found_it boolean;
BEGIN
  IF TG_TABLE_NAME = 'accounts' THEN
    acc_id := NEW.id;
  ELSE
    acc_id := OLD.account_id;
  END IF;

  SELECT a.type INTO acc_type FROM account a WHERE a.id = acc_id;
  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  EXECUTE format('SELECT EXISTS (SELECT 1 FROM %I WHERE account_id = $1)', lower(acc_role::text) || '_profiles')
    INTO found_it USING acc_id;

  IF NOT found_it THEN
    RAISE EXCEPTION 'account % has type % but no matching profile', acc_id, acc_role
      USING ERRCODE = 'integrity_constraint_violation';
  END IF;
  RETURN NULL;
END $$;

CREATE CONSTRAINT TRIGGER account_has_profile
  AFTER INSERT OR UPDATE OF role ON account
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();

CREATE CONSTRAINT TRIGGER student_profile_keeps_account_valid
  AFTER DELETE ON student_profiles
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();

CREATE CONSTRAINT TRIGGER student_profile_keeps_account_valid
  AFTER DELETE ON student_profiles
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();

CREATE CONSTRAINT TRIGGER student_profile_keeps_account_valid
  AFTER DELETE ON student_profiles
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();

CREATE CONSTRAINT TRIGGER student_profile_keeps_account_valid
  AFTER DELETE ON student_profiles
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();

CREATE CONSTRAINT TRIGGER student_profile_keeps_account_valid
  AFTER DELETE ON student_profiles
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION assert_account_has_profile();
-- Block deleting a profile if the account still exists
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON capital_humano_profiles   DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON personal_catt_profiles    DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON profesor_profiles         DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON director_externo_profiles DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
CREATE CONSTRAINT TRIGGER profile_required_trigger AFTER DELETE ON alumno_profiles           DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION assert_account_profile();
