USE nagios;
DROP TABLE IF EXISTS linktoAP;
CREATE TABLE linktoAP (
         id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
         ap_id int,
         cl_id int,
         cl_ch int,
         cl_oid int,
         cl_mac varchar(64),
         ap_oid varchar(64),
         snr int,
         timestring varchar(128),
         timestamp int(11),
         linkdate TIMESTAMP DEFAULT NOW()
      );
