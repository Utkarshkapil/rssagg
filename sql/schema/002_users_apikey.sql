-- +goose Up
CREATE OR REPLACE FUNCTION generate_api_key() RETURNS VARCHAR(64) AS $$ BEGIN RETURN encode(sha256(gen_random_uuid()::text::bytea), 'hex'); END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_api_key() RETURNS TRIGGER AS $$ BEGIN NEW.api_key := generate_api_key(); RETURN NEW; END; $$ LANGUAGE plpgsql;

ALTER TABLE users ADD COLUMN api_key VARCHAR(64) UNIQUE;

UPDATE users SET api_key = generate_api_key();

CREATE TRIGGER users_api_key_trigger BEFORE INSERT ON users FOR EACH ROW EXECUTE FUNCTION set_api_key();

ALTER TABLE users ALTER COLUMN api_key SET NOT NULL;

-- +goose Down
DROP TRIGGER IF EXISTS users_api_key_trigger ON users;
DROP FUNCTION IF EXISTS set_api_key;
DROP FUNCTION IF EXISTS generate_api_key;
ALTER TABLE users DROP COLUMN api_key;