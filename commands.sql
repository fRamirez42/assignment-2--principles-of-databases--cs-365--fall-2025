DROP DATABASE IF EXISTS passwords;
CREATE DATABASE passwords DEFAULT CHARACTER SET utf8mb4;
USE passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('the dog in the field', 512));
SET @init_vector = RANDOM_BYTES(16);

source setup.sql;

INSERT INTO sites VALUES
    (1, "https://mail.google.com"),
    (2, "https://facebook.com"),
    (3, "https://github.com"),
    (4, "https://youtube.com"),
    (5, "https://steam.com")
    (6, "https://hartford.edu");

INSERT INTO accounts VALUES
    (1, 1, "theshowman@gmail.com", "theshowman"),
    (1, 2, "feliperam1990@gmail.com", "feliperam"),
    (2, 3, "feliperam1990@gmail.com", "feliper44"),
    (3, 4, "felipeprofessional@gmail.com", "felipe24"),
    (5, 5, "feliperam1990@gmail.com", "WeBall1234"),
    (5, 6, "theshowman@gmail.com", "TheShowManIsHere!"),
    (6, 7, "jdoe@hartford.edu", "jdoe");

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
