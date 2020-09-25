--1
USE [msdb]
GO

/****** Object:  Job [Quarterly Report]    Script Date: 6/12/2020 2:25:51 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 6/12/2020 2:25:51 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Quarterly Report', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Generate quarterly report of all transactions that occur', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'DESKTOP-15HGRPJ\ivan1', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Quarterly Report]    Script Date: 6/12/2020 2:25:51 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Quarterly Report', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SELECT HT.TransactionID,
	   MC.CustomerName,
	   MS.StaffName,
	   HT.TransactionDate,
	   [Total Item] = COUNT(DT.ItemID),
	   [Total Quantity] = SUM(DT.Quantity),
	   [Total Purchase] = SUM(DT.Quantity * MI.ItemPrice)
FROM MsCustomer MC JOIN HeaderTransaction HT ON MC.CustomerID = HT.CustomerID JOIN
	 MsStaff MS ON HT.StaffID = MS.StaffID JOIN
	 DetailTransaction DT ON HT.TransactionID = DT.TransactionID JOIN
	 MsItem MI ON DT.ItemID = MI.ItemID
GROUP BY HT.TransactionID, MC.CustomerName, MS.StaffName, HT.TransactionDate', 
		@database_name=N'Sociolla', 
		@output_file_name=N'E:\Semester 4\Database Administrator\2201731440_IvanChristian\ReportDetails.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Quarterly Report', 
		@enabled=1, 
		@freq_type=32, 
		@freq_interval=8, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=16, 
		@freq_recurrence_factor=3, 
		@active_start_date=20200611, 
		@active_end_date=99991231, 
		@active_start_time=230000, 
		@active_end_time=235959, 
		@schedule_uid=N'de5efd03-1f90-41e8-8cc6-063372f16d43'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

--QueryNo1
SELECT HT.TransactionID,
	   MC.CustomerName,
	   MS.StaffName,
	   HT.TransactionDate,
	   [Total Item] = COUNT(DT.ItemID),
	   [Total Quantity] = SUM(DT.Quantity),
	   [Total Purchase] = SUM(DT.Quantity * MI.ItemPrice)
FROM MsCustomer MC JOIN HeaderTransaction HT ON MC.CustomerID = HT.CustomerID JOIN
	 MsStaff MS ON HT.StaffID = MS.StaffID JOIN
	 DetailTransaction DT ON HT.TransactionID = DT.TransactionID JOIN
	 MsItem MI ON DT.ItemID = MI.ItemID
WHERE MONTH(HT.TransactionDate) = 4
GROUP BY HT.TransactionID, MC.CustomerName, MS.StaffName, HT.TransactionDate

--2
USE [msdb]
GO

/****** Object:  Job [Remaining Stock Report]    Script Date: 6/12/2020 2:26:21 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Data Collector]    Script Date: 6/12/2020 2:26:21 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Data Collector' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Data Collector'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Remaining Stock Report', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Generate a report to print out the remaining stock of every item', 
		@category_name=N'Data Collector', 
		@owner_login_name=N'DESKTOP-15HGRPJ\ivan1', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Remaining Stock Report]    Script Date: 6/12/2020 2:26:21 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Remaining Stock Report', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'SELECT MI.ItemID,
	   MI.ItemName,
	   [Remaining] = MI.ItemStock - DT.Quantity
FROM MsItem MI JOIN DetailTransaction DT ON MI.ItemID = DT.ItemID
GROUP BY MI.ItemID, MI.ItemName, MI.ItemStock, DT.Quantity', 
		@database_name=N'Sociolla', 
		@output_file_name=N'E:\Semester 4\Database Administrator\2201731440_IvanChristian\RemainingStock.txt', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Remaining Stock Report', 
		@enabled=1, 
		@freq_type=32, 
		@freq_interval=10, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=16, 
		@freq_recurrence_factor=2, 
		@active_start_date=20200611, 
		@active_end_date=99991231, 
		@active_start_time=223000, 
		@active_end_time=235959, 
		@schedule_uid=N'94e28b83-d3f2-4c46-8966-d501cc5436b5'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

--QueryNo2
SELECT DT.ItemID,
	   MI.ItemName,
	   [Remaining] = MI.ItemStock - DT.Quantity
FROM MsItem MI JOIN DetailTransaction DT ON MI.ItemID = DT.ItemID
GROUP BY DT.ItemID, MI.ItemName, MI.ItemStock, DT.Quantity

--3
CREATE PROCEDURE ValidateItem
	@id CHAR(5),
	@name VARCHAR(50),
	@stock INT,
	@price BIGINT,
	@brand CHAR(5),
	@category CHAR(5)
AS
IF EXISTS(SELECT * FROM MsItem WHERE ItemID = @id AND ItemName = @name)
	BEGIN
		PRINT 'Item already exist'
	END
ELSE IF EXISTS(SELECT * FROM MsItem WHERE ItemID != @id AND ItemName = @name)
	BEGIN
		PRINT 'This item already exists with different ID'
	END
ELSE IF EXISTS(SELECT * FROM MsItem WHERE ItemID = @id AND ItemName != @name)
	BEGIN
		PRINT 'ID must be unique'
	END
ELSE 
	BEGIN
		INSERT INTO MsItem VALUES (@id, @name, @stock, @price, @brand, @category)
	END

EXEC ValidateItem 'IT035', 'Ki Gold Set', 23, 100000, 'IB001', 'IC001'

--4
CREATE PROCEDURE RemoveItem
	@id CHAR(5)
AS
IF NOT EXISTS (SELECT ItemID FROM MsItem WHERE ItemID = @id)
	BEGIN
		PRINT 'Item doesn’t exist'
	END
ELSE IF NOT EXISTS(SELECT TOP 5 ItemName ,[TOTALQUANTITY]= SUM(QUANTITY) 
				   FROM DetailTransaction dt JOIN MsItem MI ON DT.ItemID = MI.ItemID 
				   WHERE MI.ItemID=@ID
				   GROUP BY ItemName
				   ORDER BY SUM(QUANTITY) DESC 
				   )
BEGIN
 PRINT 'Item cannot deleted because it is in the Top 5'
END
ELSE
	BEGIN
		UPDATE MsItem SET ItemStock = 0	WHERE ItemId = @id
	END

EXEC RemoveItem 'IT023'

SELECT * FROM MsItem

DROP PROCEDURE RemoveItem

--5
CREATE PROCEDURE DeleteItem
	@id CHAR(5)
AS
IF NOT EXISTS (SELECT ItemID FROM MsItem WHERE ItemID = @id)
	BEGIN
		PRINT 'Item doesn’t exist'
	END
ELSE IF EXISTS (SELECT MI.ItemID FROM MsItem MI JOIN DetailTransaction DT ON MI.ItemID = DT.ItemID GROUP BY MI.ItemID HAVING COUNT(MI.ItemID) > 0)
	BEGIN
		PRINT 'Item cannot be removed'
	END
ELSE
	BEGIN
		DELETE FROM MsItem WHERE ItemID = @id
	END

BEGIN TRAN
EXEC DeleteItem 'IT034'
ROLLBACK TRAN

--6
GO
CREATE TRIGGER InsertItemTrigger
ON MsItem
INSTEAD OF INSERT
AS
	DECLARE @id CHAR(5);
	DECLARE	@name VARCHAR(50);
	DECLARE	@stock INT;
	DECLARE	@price BIGINT;
	DECLARE	@brand CHAR(5);
	DECLARE	@category CHAR(5);
		
SELECT ItemID = @id, ItemName = @name, ItemStock = @stock, ItemPrice = @price, ItemBrandID = @brand, ItemCategoryID = @category FROM INSERTED
BEGIN
	IF EXISTS(SELECT MI.ItemID FROM MsItem MI WHERE MI.ItemID = @id)
		BEGIN
			PRINT 'Item ID already exists'
		END
	ELSE IF @id NOT LIKE 'IT[0-9][0-9][0-9]' 
		BEGIN
			PRINT 'Item ID must be in the right format'
		END
	ELSE IF @stock < 10
		BEGIN
			PRINT 'Item Stock must be greater than 10'
		END
	ELSE IF @brand NOT LIKE 'IB[0-9][0-9][0-9]'
		BEGIN
			PRINT 'Item Brand must be in the right format'
		END 
	ELSE IF @brand NOT IN (SELECT ItemBrandID FROM MsItemBrand)
		BEGIN
			PRINT @brand + ' doesn’t exist'
		END
	ELSE IF @category NOT LIKE 'IC[0-9][0-9][0-9]'
		BEGIN
			PRINT 'Item Category must be in the right format'
		END
	ELSE IF @category NOT IN (SELECT ItemCategoryID FROM MsItemCategory)
		BEGIN
			PRINT @category + ' doesn’t exist'
		END
	ELSE
		BEGIN
			INSERT INTO MsItem VALUES (@id, @name, @stock, @price, @brand, @category)
		END
END

DROP TRIGGER InsertItemTrigger

BEGIN TRAN
INSERT INTO MsItem VALUES('IT034', 'Medheal Set', 14, 300000, 'IB015', 'IB005')
ROLLBACK TRAN

SELECT * FROM MsItem

--7
CREATE TRIGGER RefundTransaction
ON HeaderTransaction
FOR UPDATE
AS
BEGIN
	DECLARE @trans char(5)
	DECLARE @paymenttype char(5)
	DECLARE @tanggal date
	DECLARE @stock INT
SET @trans=(SELECT I.CustomerID FROM inserted I JOIN deleted D ON I.CustomerID = D.CustomerID)
SET @paymenttype=(SELECT D.PaymentTypeID FROM inserted I JOIN deleted D ON I.CustomerID = D.CustomerID)
SET @tanggal=(SELECT TransactionDate From HeaderTransaction HT WHERE HT.CustomerID = @trans)
SET @stock=(SELECT ItemStock FROM MsItem MI, DetailTransaction DT, HeaderTransaction HT WHERE MI.ItemID = DT.ItemID AND DT.TransactionID = HT.TransactionID AND HT.CustomerID = @trans)
	
	PRINT 'Old Transaction'
	PRINT '---------------'
	PRINT 'Payment Type: ' + @paymenttype
	PRINT 'Transaction Date: '+CAST(@tanggal AS VARCHAR(50))
	PRINT 'Previous Stock: '+CAST(@stock AS VARCHAR(50))
	
	PRINT''
SET @paymenttype=(SELECT I.PaymentTypeID FROM inserted I JOIN deleted D ON I.CustomerID = D.CustomerID)
SET @tanggal=(SELECT TransactionDate = GETDATE() FROM HeaderTransaction HT WHERE HT.CustomerID = @trans)
SET @stock=(SELECT ItemStock = ItemStock+Quantity FROM MsItem MI, DetailTransaction DT,HeaderTransaction HT WHERE MI.ItemID = DT.ItemID AND DT.TransactionID= HT.TransactionID AND HT.CustomerID = @trans)

	PRINT 'New Transaction'
	PRINT '---------------'
	PRINT 'Payment Type: '+@paymenttype
	PRINT 'Transaction Date: '+CAST(@tanggal AS VARCHAR(50))
	PRINT 'Previous Stock: '+CAST(@stock AS VARCHAR(50))
END
 
--8
GO
CREATE PROCEDURE PrintReceipt (@TransactionID CHAR(5))
AS
	DECLARE	@CustomerName VARCHAR (50)
	DECLARE	@TransactionDate DATE
	DECLARE	@StaffName VARCHAR (50)
	DECLARE	@PaymentTypeName VARCHAR(50)
	DECLARE	@ItemName VARCHAR (50)
	DECLARE	@Quantity INT
	DECLARE	@ItemBrandName VARCHAR (50)
	DECLARE	@ItemCategoryName VARCHAR (50)
	DECLARE	@ItemPrice INT
	DECLARE	@TempTotal INT
	DECLARE	@TempTotalItem INT
	DECLARE	@TotalItem INT = 0
	DECLARE	@TotaL INT= 0

SELECT @CustomerName = CustomerName, @TransactionDate=TransactionDate, @StaffName = StaffName, @PaymentTypeName = PaymentTypeName
FROM HeaderTransaction HT JOIN MsCustomer MC ON MC.CustomerID = HT.CustomerID JOIN 
	 MsStaff MS ON MS.StaffID = HT.StaffID JOIN 
	 MsPaymentType MP ON MP.PaymentTypeID = HT.[PaymentTypeID]
WHERE TransactionID = @TransactionID

PRINT 'Hi, ' + @CustomerName
PRINT 'Here are your shopping details'
PRINT 'Transaction Date :' + CAST(CONVERT(VARCHAR,@TransactionDate, 107) AS VARCHAR)
PRINT 'Cashier: ' + @StaffName
PRINT 'Payment: ' + @PaymentTypeName
PRINT '-------------------------------------------'

DECLARE ItemCursor CURSOR
FOR
	SELECT ItemName, Quantity, ItemBrandName, ItemCategoryName, ItemPrice
	FROM MsItem JOIN DetailTransaction ON DetailTransaction.ItemID = MsItem.ItemID JOIN 
	MsItemBrand ON MsItemBrand.ItemBrandID = MsItem.ItemBrandID JOIN 
	MsItemCategory ON MsItem.ItemCategoryID = MsItemCategory.ItemCategoryID
	WHERE @TransactionID = TransactionID

OPEN ItemCursor
	FETCH NEXT FROM ItemCursor
	INTO @ItemName, @Quantity, @ItemBrandName, @ItemCategoryName, @ItemPrice

WHILE @@FETCH_STATUS=0
BEGIN
	SET @TempTotal = @ItemPrice*@Quantity
	SET @TempTotalItem += @Quantity

	PRINT '-------------------------------------------'
	PRINT 'Item : ' + @ItemName
	PRINT 'Quantity : ' + CAST (@Quantity AS VARCHAR)
	PRINT 'Brand : ' + @ItemBrandName
	PRINT 'Category : ' + @ItemCategoryName
	PRINT 'Price per item : ' + CAST(@ItemPrice AS VARCHAR)
	PRINT 'Total :' + CAST(@TempTotal AS VARCHAR)

	SET @Total += @TempTotal
	SET @TotalItem += @TempTotalItem

	FETCH NEXT FROM ItemCursor
	INTO @ItemName, @Quantity, @ItemBrandName, @ItemCategoryName, @ItemPrice
END

SELECT @TotalItem=COUNT(*)
FROM MsItem JOIN DetailTransaction ON DetailTransaction.ItemID = MsItem.ItemID
WHERE TransactionID = @TransactionID
GROUP BY TransactionID

	PRINT '-------------------------------------------'
	PRINT 'Total Item : ' + CAST(@TotalItem AS VARCHAR)
	PRINT 'Total Price : Rp.' + CAST(@Total AS VARCHAR)

CLOSE ItemCursor
DEALLOCATE ItemCursor
		
--9
GO
CREATE PROCEDURE SearchItem (@brand VARCHAR(50))
AS
	DECLARE @id CHAR(5)
	DECLARE @name VARCHAR(50)
	DECLARE @stock INT
	DECLARE @price INT
	DECLARE @counter INT = 1

SELECT CHARINDEX(@brand, MB.ItemBrandName)
FROM MsItemBrand MB 
WHERE @brand = MB.ItemBrandName

IF LEN(@brand) < 3
	PRINT 'Keyword must be longer than 3 characters'
ELSE IF @brand NOT IN (SELECT ItemBrandName FROM MsItemBrand)
	PRINT 'Brand doesn’t exist'
ELSE 
	PRINT 'Brand: ' + @brand
	PRINT '-------------------------------------------'
	PRINT '-------------------------------------------'
	DECLARE BrandCursor CURSOR 
	FOR
	SELECT MB.ItemBrandID, MI.ItemName, MI.ItemStock, Mi.ItemPrice
	FROM MsItemBrand MB JOIN MsItem MI ON MB.ItemBrandID = MI.ItemBrandID
	WHERE @brand = MB.ItemBrandName

	OPEN BrandCursor
			FETCH NEXT FROM BrandCursor
			INTO @id, @name, @stock, @price
			WHILE @@FETCH_STATUS=0
			IF @counter = 1
			BEGIN
				PRINT 'Item ID: ' + @id
				PRINT 'Item Name: ' + @name
				PRINT 'Item Stock: ' + CAST(@stock AS VARCHAR(50))
				PRINT 'Item Price: ' + CAST(@price AS VARCHAR(50))
				PRINT '-------------------------------------------'
				PRINT '-------------------------------------------'
			FETCH NEXT FROM BrandCursor
			INTO @id, @name, @stock, @price
			END
			SET @counter = @counter + 1
	CLOSE BrandCursor
	DEALLOCATE BrandCursor

	DROP PROCEDURE SearchItem

	SELECT * FROM MsItem
	EXEC SearchItem 'Cetaphil'

--10
GO
CREATE PROCEDURE DisplayTransaction (@Start INT, @End INT, @Year INT)
AS
	DECLARE	@TransactionID CHAR(5)
	DECLARE	@TransactionDate DATE
	DECLARE	@Name VARCHAR(50)
	DECLARE	@Price INT
	DECLARE	@Quantity INT
	DECLARE	@Total INT = 0
	DECLARE	@TempTotal INT
	DECLARE	@Count INT = 1

IF((@End - @Start) > 10)
	PRINT 'The maximum range is 10 months'
ELSE
	BEGIN
	PRINT 'Showing results from ' + CAST(DATENAME(MONTH,@Start) AS VARCHAR) + ' until ' + CAST(DATENAME(MONTH,@End) AS VARCHAR) + CAST(@Year AS VARCHAR)
	
	DECLARE DateCursor CURSOR
	FOR	
	SELECT TransactionID, TransactionDate
	FROM HeaderTransaction
	WHERE CAST(MONTH(TransactionDate) AS INT)>=@Start AND CAST(MONTH(TransactionDate) AS INT)<=@End AND YEAR(TransactionDate) = @Year

	OPEN DateCursor
		FETCH NEXT FROM DateCursor
		INTO @TransactionID, @TransactionDate

		WHILE @@FETCH_STATUS = 0
		BEGIN
		PRINT '-----------------------------------------------'
		PRINT 'Transcation ID: ' + @TransactionID
		PRINT 'Transaction Date: ' + CAST(@TransactionDate AS VARCHAR)
		PRINT '-----------------------------------------------'

			DECLARE ItemCursor CURSOR
			FOR
				SELECT ItemName, Quantity, ItemPrice
				FROM MsItem 
				JOIN DetailTransaction ON DetailTransaction.ItemID = MsItem.ItemID
				JOIN MsItemBrand ON MsItemBrand.ItemBrandID = MsItem.ItemBrandID
				JOIN MsItemCategory ON MsItem.ItemCategoryID = MsItemCategory.ItemCategoryID
				WHERE @TransactionID = TransactionID

			OPEN ItemCursor
				FETCH NEXT FROM ItemCursor
				INTO @Name, @Quantity, @Price

				WHILE @@FETCH_STATUS=0
				BEGIN
					SET @TempTotal=@Price*@Quantity
									
									
					PRINT CAST(@Count AS VARCHAR)+'.'+@Name + ' - ' + CAST(@Price AS VARCHAR)
					PRINT 'Quantity : ' + CAST (@Quantity AS VARCHAR)
					PRINT 'Total :' + CAST(@TempTotal AS VARCHAR)

					SET @Total += @TempTotal
					SET @Count += 1

				FETCH NEXT FROM ItemCursor
				INTO @Name, @Quantity, @Price
				END
				SET @Count = 1
				PRINT 'Total Price : ' + CAST(@Total AS VARCHAR)
							
				CLOSE ItemCursor
				DEALLOCATE ItemCursor
		FETCH NEXT FROM DateCursor
		INTO @TransactionID, @TransactionDate
		END

		CLOSE DateCursor
		DEALLOCATE DateCursor

	END