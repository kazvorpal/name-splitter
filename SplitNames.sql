CREATE PROCEDURE SplitNames
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('People') AND name = 'MiddleName')
    BEGIN
        ALTER TABLE People ADD MiddleName VARCHAR(255);
    END

    SELECT
        ID,
        LEFT(FirstName, CHARINDEX(' ', FirstName + ' ') - 1) AS FName,
        STUFF(FirstName, 1, CHARINDEX(' ', FirstName + ' '), '') AS MName
    INTO #TempPeople
    FROM People
    WHERE FirstName IS NOT NULL AND CHARINDEX(' ', FirstName) > 0
    
    UPDATE p
    SET 
        p.FirstName = tp.FName,
        p.MiddleName = tp.MName
    FROM People p
    JOIN #TempPeople tp ON p.ID = tp.ID;
    
    DROP TABLE #TempPeople;
END
