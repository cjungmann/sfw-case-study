DELIMITER $$

DROP PROCEDURE IF EXISTS App_Household_List $$
CREATE PROCEDURE App_Household_List(hhold_id INT UNSIGNED)
BEGIN
  SELECT h.id, h.lname, p.fname,
    FROM Household h INNER JOIN Person p ON p.id_hhold = h.id
   WHERE hhold_id IS NULL OR h.id=hhold_id;
END $$


DROP PROCEDURE IF EXISTS App_Household_Read $$
CREATE PROCEDURE App_Household_Read(hhold_id INT UNSIGNED)
BEGIN
   SELECT h.id, h.lname
     FROM Household h
    WHERE hhold_id = h.id
END $$

DROP PROCEDURE IF EXISTS App_Household_Update $$
CREATE PROCEDURE App_Household_Update(hhold_id INT UNSIGNED,
                                      lname    VARCHAR(30))
BEGIN
   UPDATE Household
      SET lname = lname
    WHERE id = hhold_id;

   IF ROW_COUNT() > 0 THEN
      CALL App_Household_List(hhold_id)
   END IF;
END $$


DROP PROCEDURE IF EXISTS App_Household_Add $$
CREATE PROCEDURE App_Household_Add(lname VARCHAR(30))
BEGIN
   INSERT INTO Household (lname) VALUES (lname);

   IF ROW_COUNT() > 0 THEN
      CALL App_Household_List(hhold_id)
   END IF;
END $$

DROP PROCEDURE IF EXISTS App_Household_Delete $$
CREATE PROCEDURE App_Household_Delete(hhold_id INT UNSIGNED)
BEGIN
   DELETE FROM Person
    WHERE id_hhold = hhold_id;

   DELETE FROM Household
    WHERE id = hhold_id;

   SELECT ROW_COUNT() AS deleted;
END $$

DROP PROCEDURE IF EXISTS App_Household_Person_List $$
CREATE PROCEDURE App_Household_Person_List(person_id INT UNSIGNED)
BEGIN
END $$


