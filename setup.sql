DROP DATABASE IF EXISTS passwords;
CREATE DATABASE passwords DEFAULT CHARACTER SET utf8mb4;
USE passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('the dog in the field', 512));
SET @init_vector = RANDOM_BYTES(16);

CREATE TABLE IF NOT EXISTS sites (
  site_ID     INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  url         VARCHAR(512)  NOT NULL,

  PRIMARY KEY (site_ID),
  UNIQUE KEY unique_site_url (url)
);

CREATE TABLE IF NOT EXISTS accounts (
  site_ID     INT UNSIGNED  NOT NULL,
  account_ID  INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  email       VARCHAR(256)  NOT NULL,
  username    VARCHAR(256)  NOT NULL,

  PRIMARY KEY(account_ID)
);

CREATE TABLE IF NOT EXISTS passwords (
  pass_ID           INT UNSIGNED    NOT NULL AUTO_INCREMENT,
  account_ID        INT UNSIGNED    NOT NULL,
  password          VARBINARY(256)  NOT NULL,
  time_of_creation  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comment           VARCHAR(256)    NULL,
  is_current        TINYINT(1)     NOT NULL,

  PRIMARY KEY(pass_ID)
);

INSERT INTO sites VALUES
    (1, "https://mail.google.com"),
    (2, "https://facebook.com"),
    (3, "https://github.com"),
    (4, "https://youtube.com"),
    (5, "https://steam.com"),
    (6, "https://hartford.edu");

INSERT INTO accounts (site_ID, email, username) VALUES
  (1, "theshowman@gmail.com", "theshowman"),
  (1, "feliperam1990@gmail.com", "feliperam"),
  (2, "feliperam1990@gmail.com", "feliper44"),
  (3, "felipeprofessional@gmail.com", "felipe24"),
  (5, "feliperam1990@gmail.com", "WeBall1234"),
  (5, "theshowman@gmail.com", "TheShowManIsHere!"),
  (6, "jdoe@hartford.edu", "jdoe");


INSERT INTO passwords 
VALUES (
    1, 
    1, 
    AES_ENCRYPT('HughJackman1234', @key_str, @init_vector), 
    2025-10-6, 
    NULL, 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    2, 
    AES_ENCRYPT('SuperMario123', @key_str, @init_vector), 
    2010-6-24, 
    "Childish, and forgot", 
    0
);

INSERT INTO passwords 
VALUES (
    2, 
    2, 
    AES_ENCRYPT('ProfessionalPassword26$', @key_str, @init_vector), 
    2022-2-27, 
    NULL, 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    3, 
    AES_ENCRYPT('GoldenRetriver56!', @key_str, @init_vector), 
    2012-4-29, 
    "Got Hacked", 
    0
);

INSERT INTO passwords 
VALUES (
    2, 
    3, 
    AES_ENCRYPT('ThaWorldo98&', @key_str, @init_vector), 
    2017-1-31, 
    NULL, 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    4, 
    AES_ENCRYPT('FelipeRamirez9900*', @key_str, @init_vector), 
    2018-9-30, 
    NULL, 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    5, 
    AES_ENCRYPT('DaBoss67', @key_str, @init_vector), 
    2014-11-8, 
    "Forgot it", 
    0
);

INSERT INTO passwords 
VALUES (
    2, 
    5, 
    AES_ENCRYPT('RemeberThisTime11#', @key_str, @init_vector), 
    2017-12-20, 
    "Forgot it again", 
    0
);

INSERT INTO passwords 
VALUES (
    3, 
    5, 
    AES_ENCRYPT('DogGolden420@', @key_str, @init_vector), 
    2020-3-15, 
    NULL, 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    6, 
    AES_ENCRYPT('ShowmanshipIsKey12', @key_str, @init_vector), 
    2014-11-8, 
    "It is!", 
    1
);

INSERT INTO passwords 
VALUES (
    1, 
    6, 
    AES_ENCRYPT('Dexter8877%', @key_str, @init_vector), 
    2023-8-20, 
    NULL, 
    1
);
