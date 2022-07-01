# INFO-430-lab2

## Canvas Assignment Instructions
You have been hired to build a database for a musical instrument retailer called Guitar Shop.
They sell guitars, drum kits, electric basses and pianos.

They want to keep track of employees, customers, instruments and orders.

Please complete the following:
1) Connect to class server IS-HAY09.ischool.uw.edu

username: Info430

password: ********
2) Create a database named with your alias as follows: INFO430_Lab2_YourNetidAliasHere (example for me would be: INFO430_Lab2_gthay)
3) Connect to your new database (type/execute 'USE INFO430_Lab2_YourNetidAliasHere'
4) Write the SQL code to create the following tables with an emphasis on proper data types, nullability and PK/FK:

a) tblCUSTOMER (CustID, CustFname, CustLname, CustDOB)

b) tblPRODUCT_TYPE (ProdTypeID, ProdTypeName, ProdTypeDescr)

c) tblPRODUCT (ProdID, ProdName, ProdTypeID, Price, ProdDescr)

d) tblEMPLOYEE (EmpID, EmpFname, EmpLname, EmpDOB)

e) tblORDER (OrderID, OrderDate, CustID, ProductID, EmpID, Quantity)

5) Write the SQL code to populate each look-up table with three rows using INSERT statements.

6) Write the SQL code to create a stored procedure to populate tblORDER table. Be sure to pass in appropriate parameters needed to 'look-up' required values (do not pass-in ID values!!).
