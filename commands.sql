-- Command 1: Add a new entry --
INSERT INTO sites (url)
VALUES ('https://snapchat.com');

INSERT INTO accounts (site_ID, email, username)
VALUES (LAST_INSERT_ID(), 'felipe@snapchat.com', 'feliperam');

INSERT INTO passwords_data 
(account_ID, password, time_of_creation, comment, is_current)
VALUES (
  LAST_INSERT_ID(),
  AES_ENCRYPT('MyNewSnapPass2025!', UNHEX(SHA2('the dog in the field',512)), RANDOM_BYTES(16)),
  '2025-10-08',
  'Created new account entry for Snapchat site',
  1
);
