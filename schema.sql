DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS access_tokens;
DROP TABLE IF EXISTS refresh_tokens;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS user_permissions;
DROP TABLE IF EXISTS providers_credentials;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  email TEXT UNIQUE,
  phone TEXT UNIQUE,
  password TEXT,
  provider_id INTEGER,
  application_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (provider_id) REFERENCES providers(id),
  FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- Create the roles table
CREATE TABLE roles (
  id INTEGER PRIMARY KEY,
  name TEXT UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create the applications table
CREATE TABLE applications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  client_id BLOB NOT NULL,
  name TEXT NOT NULL,
  redirect_uri TEXT NOT NULL,
  owner_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- Create the access_tokens table
CREATE TABLE access_tokens (
  id INTEGER PRIMARY KEY,
  token TEXT UNIQUE,
  user_id INTEGER,
  application_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (application_id) REFERENCES applications (id)
);

-- Create the refresh_tokens table
CREATE TABLE refresh_tokens (
  id INTEGER PRIMARY KEY,
  token TEXT UNIQUE,
  user_id INTEGER,
  application_id INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (application_id) REFERENCES applications (id)
);

-- Permissions table
CREATE TABLE permissions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Providers table
CREATE TABLE providers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT,
  data JSON,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
  user_id INTEGER NOT NULL,
  role_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (role_id) REFERENCES roles(id)
);

CREATE TABLE user_permissions (
  user_id INTEGER NOT NULL,
  permission_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (permission_id) REFERENCES permissions(id)
);

CREATE TABLE providers_credentials (
  id INTEGER PRIMARY KEY,
  provider_id INTEGER NOT NULL,
  key TEXT NOT NULL,
  secret TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Insert a new application
INSERT INTO applications (name, redirect_uri, client_id)
VALUES ('My Application', 'http://example.com/redirect', '0x1aec66176882a6ccbc004bcbfc7abdbbe458d90c40');

-- Insert a new provider
INSERT INTO providers (name, description, created_at, updated_at)
VALUES ('Email', 'Email login with password.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert a new user, using the values stored in the local variables
INSERT INTO users (name, email, phone, password, provider_id, application_id)
VALUES ('John Doe', 'johndoe@example.com', '1234567890', 'password123', 1, 1);

UPDATE applications
SET owner_id = 1
WHERE client_id = '0x1aec66176882a6ccbc004bcbfc7abdbbe458d90c40';