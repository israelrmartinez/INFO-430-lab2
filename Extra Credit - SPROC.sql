--*************************************************************************--
-- Title: Extra Credit SPOC
-- Author: IMartinez
-- Desc: Jan 13 Extra Credit
-- 2021-01-13,IMartinez,Created File
--**************************************************************************--
Use INFO430_Lab2_israelma;
go

Create Procedure insEVENT
(@EventName nvarchar(100), @EventTypeID int, @EventDescr varchar(500), @EventDate date)
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into tblEVENT(EventName, EventTypeID, EventDescr, EventDate)
	Values (@EventName, @EventTypeID, @EventDescr, @EventDate);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print 'Hey...there is an error; time to rollback this transaction'
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure insEVENT_TYPE
(@EventTypeName varchar(50), @EventTypeDescr varchar(500))
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into tblEVENT_TYPE(EventTypeName, EventTypeDecsr)
	Values (@EventTypeName, @EventTypeDescr);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print 'Hey...there is an error; time to rollback this transaction'
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure insMODEL
(@Modelname varchar(50), @ModelDescr varchar(1000))
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into tblMODEL(ModelName, ModelDescr)
	Values (@Modelname, @ModelDescr);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print 'Hey...there is an error; time to rollback this transaction'
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure insROCKET
(@RocketName varchar(50), @ModelID int)
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into tblROCKET(RocketName, ModelID)
	Values (@RocketName, @ModelID);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print 'Hey...there is an error; time to rollback this transaction'
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

Create Procedure insPARTICIPANT
(@Fname varchar(20), @Lname varchar(20), @BirthDate date)
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
	Insert Into tblPARTICIPANT(Fname, Lname, BirthDate)
	Values (@Fname, @Lname, @BirthDate);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print 'Hey...there is an error; time to rollback this transaction'
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go

-- need data in the look-up tables to draw from --> EVENT_TYPE, EVENT, PARTICIPANT, ROCKET, MODEL
INSERT INTO tblEVENT_TYPE (EventTypeName, EventTypeDecsr)
VALUES ('Competition', 'Any event where is an entry fee and a winner'), ('Practice', 'Any event where people show up to blow-up...throw-up')
GO

INSERT INTO tblEVENT (EventName, EventTypeID, EventDescr, EventDate)
VALUES ('Summer 2021 Spectabular', (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Competition'), 'Summer event of fun, and fire in a field fury', 'June 28, 2021')

INSERT INTO tblEVENT (EventName, EventTypeID, EventDescr, EventDate)
VALUES ('Autumn 2021 Launch Practice', (SELECT EventTypeID FROM tblEVENT_TYPE WHERE EventTypeName = 'Practice'), 'Fall event of fun, and fire in a field fury', 'August 28, 2021')

INSERT INTO tblMODEL (ModelName, ModelDescr)
VALUES ('ACME Blaster YCX-21','Funnel of fire in a 21-inch barrel'), ('Rasco NoiseBunch 34X','Smoke-filled fire bomb')

INSERT INTO tblROCKET (RocketName, ModelID)
VALUES ('Gaster 211', (SELECT ModelID FROM tblMODEL WHERE ModelName = 'ACME Blaster YCX-21')),
('Fire Pit 2000', (SELECT ModelID FROM tblMODEL WHERE ModelName = 'Rasco NoiseBunch 34X'))

INSERT INTO tblPARTICIPANT (Fname, Lname, BirthDate)
VALUES ('Kenny', 'TheCat', 'October 13, 2012'), ('Mitch', 'TheCat', 'September 24, 2011')