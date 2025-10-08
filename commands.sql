-- Command 1: Add a new entry --
SET @url      = 'https://snapchat.com';
SET @email    = 'felipe@snapchat.com';
SET @username = 'feliperam';
SET @plain    = 'MyNewSnapPass2025!';
SET @date     = '2025-10-08';
SET @comment  = 'Created new account entry for Snapchat site';
SET @is_cur   = 1;

INSERT INTO sites(url)
VALUES(@url)
ON DUPLICATE KEY UPDATE site_ID = LAST_INSERT_ID(site_ID);
SET @site_id := LAST_INSERT_ID();

INSERT INTO accounts(site_ID,email,username)
VALUES(@site_id,@email,@username)
ON DUPLICATE KEY UPDATE account_ID = LAST_INSERT_ID(account_ID);
SET @account_id := LAST_INSERT_ID();

SET @iv = RANDOM_BYTES(16);

INSERT INTO passwords_data(account_ID,password,time_of_creation,comment,is_current)
VALUES(@account_id, AES_ENCRYPT(@plain,@key_str,@iv), @date, @comment, @is_cur);

INSERT INTO password_iv_store(pass_ID, iv_value)
VALUES(LAST_INSERT_ID(), @iv);

-- Receipt
SELECT 'site_ID' AS what, @site_id AS value
UNION ALL SELECT 'account_ID', @account_id
UNION ALL SELECT 'inserted_password_rows', ROW_COUNT();

-- Command 2: Get the password associated with a URL --
SET @lookup_url = 'https://github.com';

SELECT 
  s.url, a.email, a.username,
  CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) AS decrypted_password,
  p.time_of_creation, p.comment, p.is_current, p.pass_ID
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
JOIN accounts a ON a.account_ID = p.account_ID
JOIN sites s    ON s.site_ID   = a.site_ID
WHERE s.url = @lookup_url;

-- Command 3: Get all password associated data for two entries that hold HTTPS in their URL --
SELECT 
  s.url, a.email, a.username,
  CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) AS decrypted_password,
  p.time_of_creation, p.comment, p.is_current, p.pass_ID
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
JOIN accounts a ON a.account_ID = p.account_ID
JOIN sites s    ON s.site_ID   = a.site_ID
WHERE s.url LIKE 'https%'
LIMIT 2;

-- Command 4: Change the URL associated with one of the passwords --
UPDATE sites
SET url = 'https://meta.com'
WHERE site_ID = 2;

SELECT * FROM sites;

-- Command 5: Change the password to any entry --
SET @target_pass_id = 3;
SET @new_plain      = 'MyNewSecureSnapPass2025!';
SET @new_date       = '2025-10-08';

SET @iv = RANDOM_BYTES(16);

UPDATE passwords_data
SET password = AES_ENCRYPT(@new_plain, @key_str, @iv),
    time_of_creation = @new_date
WHERE pass_ID = @target_pass_id;

-- replace/update IV row (1:1 by PK), safe upsert
INSERT INTO password_iv_store(pass_ID, iv_value)
VALUES(@target_pass_id, @iv)
ON DUPLICATE KEY UPDATE iv_value = VALUES(iv_value);

SELECT 
  p.pass_ID, p.account_ID,
  CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) AS decrypted_password,
  p.time_of_creation, p.comment, p.is_current
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
WHERE p.pass_ID = @target_pass_id;

-- Command 6: delete tuple based on URL --
DELETE p
FROM passwords_data p
JOIN accounts a ON p.account_ID = a.account_ID
JOIN sites s    ON a.site_ID   = s.site_ID
WHERE s.url = 'http://steam.com';

SELECT 
  s.url, a.email, a.username, p.pass_ID,
  CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) AS decrypted_password,
  p.time_of_creation, p.comment, p.is_current
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
JOIN accounts a ON p.account_ID = a.account_ID
JOIN sites s    ON a.site_ID   = s.site_ID
ORDER BY p.pass_ID;

-- Command 7: delete tuple based on a password --
SET @pwd_text = 'SchoolAppropriate78@';

SELECT a.account_ID, s.site_ID INTO @acc_id, @site_id
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
JOIN accounts a ON p.account_ID = a.account_ID
JOIN sites s    ON a.site_ID   = s.site_ID
WHERE CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) = @pwd_text
LIMIT 1;

DELETE FROM passwords_data WHERE account_ID = @acc_id;
DELETE FROM accounts       WHERE account_ID = @acc_id;
DELETE FROM sites
WHERE site_ID = @site_id
  AND NOT EXISTS (SELECT 1 FROM accounts WHERE site_ID = @site_id);

SELECT 
  s.url, a.email, a.username, p.pass_ID,
  CONVERT(AES_DECRYPT(p.password, @key_str, iv.iv_value) USING utf8) AS decrypted_password,
  p.time_of_creation, p.comment, p.is_current
FROM passwords_data p
JOIN password_iv_store iv ON iv.pass_ID = p.pass_ID
JOIN accounts a ON p.account_ID = a.account_ID
JOIN sites s    ON a.site_ID   = s.site_ID
ORDER BY p.pass_ID;
