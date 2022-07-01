-- Lab 2: Data Definition Language

-- CUSTOMER, PRODUCT_TYPE, PRODUCT, EMPLOYEE, ORDER
Use master
go

If Exists(Select Name from SysDatabases Where Name = 'israelma_Lab2')
 Begin 
  Alter Database israelma_Lab2 set Single_user With Rollback Immediate;
  Drop Database israelma_Lab2;
 End
go



-- (2)
Create Database israelma_Lab2;
go



-- (3)
Use israelma_Lab2;
go



-- (4)
CREATE TABLE tblCUSTOMER
(CustID INTEGER IDENTITY(1,1) primary key
,CustFname varchar(20) not null
,CustLname varchar(20) not null
,CustDOB date not null
)
go

CREATE TABLE tblPRODUCT_TYPE
(ProdTypeID INTEGER IDENTITY(1,1) primary key
,ProdTypeName varchar(50) not null
,ProdTypeDescr varchar(500) null
)
go

CREATE TABLE tblPRODUCT
(ProdID INTEGER IDENTITY(1,1) primary key
,ProdName varchar(50) not null
,ProdTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE (ProdTypeID) not null
,Price money not null
,ProdDescr varchar(500) null
)
go

CREATE TABLE tblEMPLOYEE
(EmpID INTEGER IDENTITY(1,1) primary key
,EmpFname varchar(20) not null
,EmpLname varchar(20) not null
,EmpDOB date not null
)
go

CREATE TABLE tblORDER
(OrderID INTEGER IDENTITY(1,1) primary key
,OrderDate date not null
,CustID int not null
,ProdID int not null
,EmpID int not null
,Quantity int not null
)
go

ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_CustID
FOREIGN KEY (CustID)
REFERENCES tblCUSTOMER (CustID)
go
ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_ProdID
FOREIGN KEY (ProdID)
REFERENCES tblPRODUCT (ProdID)
go
ALTER TABLE tblORDER
ADD CONSTRAINT FK_tblORDER_EmpID
FOREIGN KEY (EmpID)
REFERENCES tblEMPLOYEE (EmpID)
go



-- (5)
INSERT INTO tblCUSTOMER(CustFname, CustLname, CustDOB)
VALUES 
('Kenny', 'TheCat', 'October 13, 2012'),
('Mitch', 'TheCat', 'September 24, 2011'),
('Snitch', 'TheDog', 'September 30, 2013')
GO

INSERT INTO tblPRODUCT_TYPE(ProdTypeName, ProdTypeDescr)
VALUES
('Blaster','Funnel of fire in a 21-inch barrel'), 
('NoiseBunch','Smoke-filled bomb'),
('BunchNoise','Bomb smoke-filled')
GO

INSERT INTO tblPRODUCT(ProdName, ProdTypeID, Price, ProdDescr)
VALUES 
('ACME Blaster YCX-21', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'Blaster'), '19.99', '21 description'), 
('Rasco NoiseBunch 34X', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'NoiseBunch'), '29.99', '34 description'),
('Rasco BunchNoise 35X', (SELECT ProdTypeID FROM tblPRODUCT_TYPE WHERE ProdTypeName = 'BunchNoise'), '30.99', '35 description')
GO

INSERT INTO tblEMPLOYEE(EmpFname, EmpLname, EmpDOB)
VALUES 
('Ken', 'Kitty', 'October 6, 2012'),
('Min', 'Kitty', 'September 5, 2011'),
('Snap', 'Puppy', 'September 4, 2013')
GO



-- (6)
CREATE PROCEDURE uspGetProductID
@Product varchar(50),
@Prod_ID INT OUTPUT
AS
SET @Prod_ID = (SELECT ProdID FROM tblPRODUCT WHERE ProdName = @Product)
GO

CREATE PROCEDURE uspGetCustomerID
@F2 varchar(20),
@L2 varchar(20),
@BirthDate2 Date,
@C_ID2 INT OUTPUT
AS
SET @C_ID2 = (SELECT CustID
   FROM tblCUSTOMER
   WHERE CustFname = @F2
   AND CustLname = @L2
   AND CustDOB = @BirthDate2)
GO

CREATE PROCEDURE uspGetEmployeeID
@E_F2 varchar(20),
@E_L2 varchar(20),
@E_BirthDate2 Date,
@E_ID2 INT OUTPUT
AS
SET @E_ID2 = (SELECT EmpID
   FROM tblEMPLOYEE
   WHERE EmpFname = @E_F2
   AND EmpLname = @E_L2
   AND EmpDOB = @E_BirthDate2)
GO

CREATE PROCEDURE [dbo].[israelmaNewOrder]
@OrderDate Date,
@F varchar(20),
@L varchar(20),
@BirthDate date,
@ProductName varchar(50),
@E_F varchar(20),
@E_L varchar(20),
@E_BirthDate date,
@OrderQuantity int
AS
DECLARE @P_ID INT, @C_ID INT, @E_ID INT


EXEC uspGetProductID
@Product = @ProductName,
@Prod_ID = @P_ID OUTPUT

-- error handle @Prod_ID in case it NULL/empty
IF @P_ID IS NULL
 BEGIN
  PRINT 'Hey...whatcha doin? @P_ID is empty and will fail in the transaction'
  RAISERROR ('@P_ID cannot be NULL', 11,1)
  RETURN
 END


EXEC uspGetCustomerID
@F2 = @F,
@L2 = @L,
@BirthDate2 = @BirthDate,
@C_ID2 = @C_ID OUTPUT
-- error handle @P_ID in case it NULL/empty

IF @C_ID IS NULL
 BEGIN
  PRINT 'Hey...whatcha doin? @C_ID is empty and will fail in the transaction'
  RAISERROR ('@C_ID cannot be NULL', 11,1)
  RETURN
 END


EXEC uspGetEmployeeID
@E_F2 = @E_F,
@E_L2 = @E_L,
@E_BirthDate2 = @E_BirthDate,
@E_ID2 = @E_ID OUTPUT
-- error handle @P_ID in case it NULL/empty

IF @E_ID IS NULL
 BEGIN
  PRINT 'Hey...whatcha doin? @E_ID is empty and will fail in the transaction'
  RAISERROR ('@E_ID cannot be NULL', 11,1)
  RETURN
 END


BEGIN TRAN G1
INSERT INTO tblORDER (OrderDate, CustID, ProdID, EmpID, Quantity)
VALUES (@OrderDate, @C_ID, @P_ID, @E_ID, @OrderQuantity)
IF @@ERROR <> 0
 BEGIN
  PRINT 'Hey...there is an error; time to rollback this transaction'
  ROLLBACK TRAN G1
 END
ELSE
 COMMIT TRAN G1
 GO


EXEC israelmaNewOrder
@OrderDate = 'July 23, 2021',
@F = 'Kenny',
@L = 'TheCat',
@BirthDate = 'October 13, 2012',
@ProductName = 'Rasco NoiseBunch 34X',
@E_F = 'Ken',
@E_L = 'Kitty',
@E_BirthDate = 'October 6, 2012',
@OrderQuantity = '3'
GO
