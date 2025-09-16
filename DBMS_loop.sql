# LOOP Statement

CREATE TABLE loop_test (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loop_type VARCHAR(10),
    value INT
);

[label:] LOOP
    -- statements
    IF condition THEN
        LEAVE [label];
    END IF;
END LOOP [label];

DELIMITER $$

CREATE PROCEDURE UseLoop()
BEGIN
    DECLARE counter INT DEFAULT 0;
    
    loop_label: LOOP
        SET counter = counter + 1;
        -- INSERT INTO numbers (value) VALUES (counter);
        INSERT INTO loop_test (loop_type, value) VALUES ('LOOP', counter);
        
        -- Exit condition
        IF counter >= 3 THEN
            LEAVE loop_label;
        END IF;
    END LOOP loop_label;

    SELECT 'Loop finished.';
END$$

DELIMITER ;

-- WHILE 

[label:] WHILE condition DO
    -- statements
END WHILE [label];

DELIMITER $$

CREATE PROCEDURE UseWhile()
BEGIN
    DECLARE counter INT DEFAULT 0;
    
    WHILE counter < 5 DO
        SET counter = counter + 1;
        --INSERT INTO numbers (value) VALUES (counter);
        INSERT INTO loop_test (loop_type, value) VALUES ('WHILE', counter);
    END WHILE;
    
    SELECT 'Loop finished.';
END$$

DELIMITER ;

-- REPEAT Statement

[label:] REPEAT
    -- statements
UNTIL condition
END REPEAT [label];

DELIMITER $$

CREATE PROCEDURE UseRepeat()
BEGIN
    DECLARE counter INT DEFAULT 0;
    
    REPEAT
        SET counter = counter + 1;
        -- INSERT INTO numbers (value) VALUES (counter);
        INSERT INTO loop_test (loop_type, value) VALUES ('REPEAT', counter);
    UNTIL counter >= 5
    END REPEAT;
    
    SELECT 'Loop finished.';
END$$

DELIMITER ;

CALL UseRepeat();


--------------------------------

-- Printing a 2-Number Table

DELIMITER $$

CREATE PROCEDURE print_two_table()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE result INT;

    SELECT '2-Number Table' AS Heading;
    
    WHILE i <= 10 DO
        SET result = 2 * i;
        SELECT CONCAT('2 x ', i, ' = ', result);
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL print_two_table();

-- Summing the First 10 Numbers
DELIMITER $$

CREATE PROCEDURE sum_first_ten()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE total_sum INT DEFAULT 0;
    
    sum_loop: LOOP
        -- Add the current number to the sum
        SET total_sum = total_sum + counter;
        -- Move to the next number
        SET counter = counter + 1;
        
        -- Exit the loop when we have summed 10 numbers
        IF counter > 10 THEN
            LEAVE sum_loop;
        END IF;
    END LOOP;
    
    -- Print the final result
    SELECT CONCAT('The sum of the first 10 numbers is: ', total_sum) AS Result;
END$$

DELIMITER ;

CALL sum_first_ten();



-- print 1 to 10 


DELIMITER $$

CREATE PROCEDURE PrintNumbersInOneGo()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE output_string TEXT DEFAULT '';
    
    -- Loop to build the string
    WHILE i <= 10 DO
        SET output_string = CONCAT(output_string, i, ' ');
        SET i = i + 1;
    END WHILE;
    
    -- Select the final string
    SELECT TRIM(output_string) AS Numbers;
    
END$$

DELIMITER ;

