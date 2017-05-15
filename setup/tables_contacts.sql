SET storage_engine=InnoDB;
CREATE TABLE IF NOT EXISTS ContactList
(
   id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
   fname VARCHAR(32),
   lname VARCHAR(32),
   phone VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS QT_ContactList
(
   id_session INT UNSIGNED NOT NULL,
   fname VARCHAR(32),
   lname VARCHAR(32),
   phone VARCHAR(25),

   INDEX(id_session)
);
GRANT INSERT ON QT_ContactList to 'webuser'@'localhost';
