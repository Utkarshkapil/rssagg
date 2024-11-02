-- name: CreateUser :one
INSERT INTO users(id, created_at,updated_at,name)
VALUES($1,$2,$3,$4)
RETURNING id, created_at, updated_at, name, api_key;

-- name: GetUserByApikey :one
SELECT * FROM users WHERE api_key= $1;