USE nagios;
DROP TABLE IF EXISTS apmapping;
CREATE TABLE apmapping (
         id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
         oid INT,
         ip VARCHAR(64),
         mac VARCHAR(64),
         navn VARCHAR(256)
       );
