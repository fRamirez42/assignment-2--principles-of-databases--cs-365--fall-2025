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

-- Command 2: Get the password associated with a URL --
SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('the dog in the field',512));
SET @init_vector = x'0123456789ABCDEF0123456789ABCDEF';

SELECT s.url, a.email, a.username,
       CONVERT(AES_DECRYPT(p.password, @key_str, @init_vector) USING utf8) AS plaintext_password
FROM sites s
JOIN accounts a ON a.site_ID = s.site_ID
JOIN passwords_data p ON p.account_ID = a.account_ID
WHERE s.url = 'https://github.com';

-- Command 3: Get all password associated data for two entries that hold HTTPS in their URL --
SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('the dog in the field',512));
SET @init_vector = x'0123456789ABCDEF0123456789ABCDEF';

SELECT 
  s.url,
  a.email,
  a.username,
  CONVERT(AES_DECRYPT(p.password, @key_str, @init_vector) USING utf8) AS decrypted_password,
  p.time_of_creation,
  p.comment,
  p.is_current
FROM sites s
JOIN accounts a ON a.site_ID = s.site_ID
JOIN passwords_data p ON p.account_ID = a.account_ID
WHERE s.url LIKE 'https%'
LIMIT 2;

-- Command 4: Change the URL associated with one of the passwords --
UPDATE sites
SET url = 'https://snapchat.com'
WHERE site_ID = 5;
-- To verify --
SELECT * FROM sites;

-- Command 5: Change the password to any entry --
SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('the dog in the field',512));
SET @init_vector = x'0123456789ABCDEF0123456789ABCDEF';

UPDATE passwords_data
SET 
  password = AES_ENCRYPT('MyNewSecureSnapPass2025!', @key_str, @init_vector),
  time_of_creation = '2025-10-08'
WHERE pass_ID = 3;
-- To verify --
SELECT 
  pass_ID,
  account_ID,
  CONVERT(AES_DECRYPT(password, @key_str, @init_vector) USING utf8) AS decrypted_password,
  time_of_creation,
  comment,
  is_current
FROM passwords_data
WHERE pass_ID = 3;
