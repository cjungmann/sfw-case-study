DELIMITER $$

-- ---------------------------------------
-- Fundamental Event Management Procedures
-- ---------------------------------------

-- ---------------------------------------
DROP PROCEDURE IF EXISTS App_Event_List $$
CREATE PROCEDURE App_Event_List(event_id INT UNSIGNED)
BEGIN
   SELECT id, ename, edate
     FROM Event
    WHERE event_id IS NULL OR id = event_id;
END $$

-- ---------------------------------------
DROP PROCEDURE IF EXISTS App_Event_Read $$
CREATE PROCEDURE App_Event_Read(event_id INT UNSIGNED)
BEGIN
   SELECT id AS event_id, ename, edate
     FROM Event
    WHERE id = event_id;
END $$

-- --------------------------------------
DROP PROCEDURE IF EXISTS App_Event_Add $$
CREATE PROCEDURE App_Event_Add(ename VARCHAR(80), edate DATE)
BEGIN
   INSERT
     INTO Event(ename, edate)
   VALUES (ename, edate);

   IF ROW_COUNT() > 0 THEN
      CALL App_Event_List(LAST_INSERT_ID());
   END IF;
END $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_Event_Update $$
CREATE PROCEDURE App_Event_Update(event_id INT UNSIGNED, ename VARCHAR(80), edate DATE)
BEGIN
   UPDATE Event e
      SET e.ename = ename,
          e.edate = edate
    WHERE e.id = event_id;

   IF ROW_COUNT()>0 THEN
      CALL App_Event_List(event_id);
   END IF;
END $$

-- -----------------------------------------
DROP PROCEDURE IF EXISTS App_Event_Delete $$
CREATE PROCEDURE App_Event_Delete(event_id INT UNSIGNED)
BEGIN
   DELETE
     FROM Event
    WHERE id = event_id;

   SELECT ROW_COUNT() AS deleted;    
END $$

-- -------------------------
-- More complex interactions
-- -------------------------

-- ----------------------------------------------
DROP PROCEDURE IF EXISTS App_Event_Ranged_List $$
CREATE PROCEDURE App_Event_Ranged_List(start_date DATE,
                                       end_date DATE,
                                       event_id INT UNSIGNED)
BEGIN
   SELECT id, ename, edate
     FROM Event
    WHERE (event_id IS NULL OR id = event_id)
      AND edate >= start_date AND edate <= end_date;
END $$

-- ---------------------------------------
DROP PROCEDURE IF EXISTS App_Month_Show $$
CREATE PROCEDURE App_Month_Show(mdate DATE)
BEGIN
   DECLARE start_date DATE;
   DECLARE end_date DATE;
   
   IF mdate IS NULL THEN
      SET mdate = NOW();
   END IF;

   -- No result, just sets output parameters start_date and end_date
   CALL ssys_month_get_first_and_last(mdate, start_date, end_date);

   -- Result #1: for XSL to render month calendar containing indicated date:
   CALL ssys_month_info_result(mdate);
   
   -- Result #2: distinct from calendar in case we're displaying by weeks
   --            spanning multipe months
   SELECT start_date, end_date;

   -- Result #3 with contents of each day
   CALL App_Event_Ranged_List(start_date, end_date,NULL);
END $$

-- -------------------------------------
DROP PROCEDURE IF EXISTS App_Day_Read $$
CREATE PROCEDURE App_Day_Read(ddate DATE)
BEGIN
   SELECT id, ename
     FROM Event
    WHERE ddate = edate;

   SELECT DATE_FORMAT(ddate, '%Y-%m-%d') AS ddate, DAYNAME(ddate) AS ddow;
END $$


DELIMITER ;
