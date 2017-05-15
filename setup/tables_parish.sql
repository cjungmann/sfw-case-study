SET storage_engine=InnoDB;

CREATE TABLE IF NOT EXISTS Household
(
   id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   lname VARCHAR(80) NOT NULL,
   extid VARCHAR(25) NULL,    -- optional external source ID

   INDEX(lname),
   INDEX(extid)
);


CREATE TABLE IF NOT EXISTS Person
(
   id       INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   id_hhold INT UNSIGNED NOT NULL,
   fname    VARCHAR(30) NOT NULL,
   lname    VARCHAR(30) NOT NULL,
   email    VARCHAR(128) NULL,

   INDEX(id_hhold),
   INDEX(lname)
);

