-- Part 2: Fun with Triggers - Step-by-Step Scripts
-- Table: [dbo].[t_w3_schools_customers]

-- Step 1: Start with a question
-- EC_IT143_6.3_fwt_s1_fg.sql
-- Question: How can we keep track of when a customer record was last modified?

-- Step 2: Begin creating an answer
-- EC_IT143_6.3_fwt_s2_fg.sql
-- Answer: We need to add a new column to store the last modified date.
-- Next logical step: Add column [last_modified_date]

ALTER TABLE dbo.t_w3_schools_customers
ADD last_modified_date DATETIME;

-- Step 3: Research and test a solution
-- EC_IT143_6.3_fwt_s3_fg.sql
-- Test updating a row manually to see if the new column can hold datetime values.

UPDATE dbo.t_w3_schools_customers
SET last_modified_date = GETDATE()
WHERE CustomerID = 1;

-- Step 4: Create an AFTER UPDATE trigger
-- EC_IT143_6.3_fwt_s4_fg.sql

CREATE TRIGGER trg_UpdateLastModifiedDate
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET last_modified_date = GETDATE()
    FROM dbo.t_w3_schools_customers AS c
    INNER JOIN inserted AS i ON c.CustomerID = i.CustomerID;
END;

-- Step 5: Test results
-- EC_IT143_6.3_fwt_s5_fg.sql
-- Update a record and check if the trigger sets the last_modified_date

UPDATE dbo.t_w3_schools_customers
SET CustomerName = 'Updated Name'
WHERE CustomerID = 1;

SELECT CustomerID, CustomerName, last_modified_date
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;

-- Step 6: Ask the next question
-- EC_IT143_6.3_fwt_s6_fg.sql
-- Question: How can we also record who made the last modification?

-- Add a column to store the username
ALTER TABLE dbo.t_w3_schools_customers
ADD last_modified_by NVARCHAR(100);

-- Create a second trigger
CREATE TRIGGER trg_UpdateLastModifiedBy
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE c
    SET last_modified_by = SUSER_NAME()
    FROM dbo.t_w3_schools_customers AS c
    INNER JOIN inserted AS i ON c.CustomerID = i.CustomerID;
END;

-- Test the new trigger
UPDATE dbo.t_w3_schools_customers
SET CustomerName = 'Another Update'
WHERE CustomerID = 1;

SELECT CustomerID, CustomerName, last_modified_date, last_modified_by
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;
