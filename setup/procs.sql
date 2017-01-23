DELIMITER $$

-- "L" part of L-CRUD
DROP PROCEDURE IF EXISTS App_Contact_List $$
CREATE PROCEDURE App_Contact_List(id INT UNSIGNED)
BEGIN
   SELECT c.id, c.fname, c.lname, c.phone
     FROM ContactList c
    WHERE id IS NULL OR c.id=id;
END $$

-- "C" part of L-CRUD
DROP PROCEDURE IF EXISTS App_Contact_Create $$
CREATE PROCEDURE App_Contact_Create(fname VARCHAR(32),
                                    lname VARCHAR(32),
                                    phone VARCHAR(25))
BEGIN
   DECLARE new_id INT UNSIGNED;

   INSERT
     INTO ContactList (fname, lname, phone)
   VALUES (fname, lname, phone);

   IF ROW_COUNT() > 0 THEN
      SET new_id = LAST_INSERT_ID();
      CALL App_Contact_List(new_id);
   END IF;
END $$

-- "R" part of L-CRUD
DROP PROCEDURE IF EXISTS App_Contact_Value $$
CREATE PROCEDURE App_Contact_Value(id INT UNSIGNED)
BEGIN
   SELECT c.id, c.fname, c.lname, c.phone
     FROM ContactList c
    WHERE c.id = id;
END $$

-- "U" part of L-CRUD
DROP PROCEDURE IF EXISTS App_Contact_Update $$
CREATE PROCEDURE App_Contact_Update(id INT UNSIGNED,
                                    fname VARCHAR(32),
                                    lname VARCHAR(32),
                                    phone VARCHAR(25))
BEGIN
   UPDATE ContactList c
      SET c.fname = fname,
          c.lname = lname,
          c.phone = phone
    WHERE c.id = id;

   IF ROW_COUNT() > 0 THEN
      CALL App_Contact_List(id);
   END IF;
END $$

-- "D" part of L-CRUD
DROP PROCEDURE IF EXISTS App_Contact_Delete $$
CREATE PROCEDURE App_Contact_Delete(id INT UNSIGNED, fname VARCHAR(32))
BEGIN
   DELETE
     FROM c USING ContactList AS c
    WHERE c.id = id and c.fname = fname;

   SELECT ROW_COUNT() AS deleted;
END $$


-- Export
DROP PROCEDURE IF EXISTS App_Contacts_Export $$
CREATE PROCEDURE App_Contacts_Export()
BEGIN
   SELECT fname, lname, phone
     FROM ContactList;
END $$


-- Import confirm
DROP PROCEDURE IF EXISTS App_Contacts_Import_Review $$
CREATE PROCEDURE App_Contacts_Import_Review()
BEGIN
   SELECT fname, lname, phone
     FROM QT_ContactList
    WHERE id_session = @session_confirmed_id;
END $$

-- Import abandon
DROP PROCEDURE IF EXISTS App_Contacts_Import_Abandon $$
CREATE PROCEDURE App_Contacts_Import_Abandon()
BEGIN
   DELETE
     FROM QT_ContactList
    WHERE id_session = @session_confirmed_id;
END $$

-- Import save
DROP PROCEDURE IF EXISTS App_Contacts_Import_Save $$
CREATE PROCEDURE App_Contacts_Import_Save()
BEGIN
   INSERT
     INTO ContactList (fname, lname, phone)
          SELECT fname, lname, phone
            FROM QT_ContactList
           WHERE id_session = @session_confirmed_id;

  CALL App_Contacts_Import_Abandon();
END $$


-- Large Export Test
DROP PROCEDURE IF EXISTS App_Export_Big $$
CREATE PROCEDURE App_Export_Big()
BEGIN
   SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_ROWS, CREATE_TIME, TABLE_COMMENT
     FROM information_schema.TABLES;
END $$



DELIMITER ;
