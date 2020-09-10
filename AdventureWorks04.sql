/* Short-answer Questions
1. What is View? What are the benefits of using views?
Ans: A view is a virtual table whose contents are defined by a query. Like a real table,
a view consists of a set of named columns and rows of data.
Benefits:
a) to simplify data manipulation,
b) backward compatibility when its schema changes,
c) customized data,
d) ability to define views that use data from multiple heterogeneous sources, 
e) ability to combine similarly structured data from different servers.

2. Can data be modified through views?
Ans: You can insert, update, and delete rows in a view, subject to the following limitation
a) If the view contains JOINs between multiple tables, you can only insert and update one table in the view, and you cannot DELETE rows.
b) You cannot directly modify data in views based on union queries.
You cannot modify data in views that user GROUP BY or DISTINCT statements.
c) All columns being modified are subject to the same restrictions as if the statements were being executed directly against the base table.
d) Text and image columns cannot be modified through views.
e) There is no checking of view criteria.

3. What is stored procedure and what are the benefits of using it?
Ans: A stored procedure groups one or more Transact-SQL statements into a logical unit, stored as an object in a SQL Server database.
Benefits: 
a) increase database security
b) faster execution
c) centralized Transact-SQL code in the data tier
d) reduce network traffic for larger ad hoc queries
e) encourage code reusability

4. What is the difference between view and stored procedure?
Ans: A view represents a virtual table. You can join multiple tables in a view and use the view to present the data as if
the data were coming from a single table. A stored procedure uses parameters to do a function
(whether it is updating and inserting data, or returning single values or data sets).

5. What is the difference between stored procedure and functions?
Ans: Stored procedures are pre-compiled objects which are compiled for the first time and its compiled format is saved,
which executes the compiled code whenever it is called. A function is compiled and executed every time whenever it is called.
A function must return a value and cannot modify the data received as parameters.

6. Can stored procedure return multiple result sets?
Ans: Yes. A stored procedure can return zero or multiple values.

7. Can stored procedure be executed as part of SELECT Statement? Why?
Ans: No. Stored procedures cannot be executed as part of SELECT statement.

8. What is Trigger? What types of Triggers are there?
Ans: Triggers are a special type of stored procedure that is executed (fired) when a specific event happens.
DML Trigger types: insert, delete, update, for/after, and instead of. DDL Trigger types: create, alter, drop, for/after.

9. What are the scenarios to use Triggers?
Ans:
a. enforce integrity beyond simple referential integrity
b. implement business rules
c. maintain audit record of changes
d. accomplish cascading updates and deletes

10. What is the difference between Trigger and Stored Procedure?
Ans: Triggers are automatically fired on an event and cannot be explicitly executed.
*/

/* Quesry questions (Northwind) */

--Question 1--
/*
Lock tables Region, Territories, EmployeeTerritories and Employees. Insert following information into the database. In case of an error, no changes should be made to DB.
a. A new region called “Middle Earth”;
b. A new territory called “Gondor”, belongs to region “Middle Earth”;
c. A new employee “Aragorn King” who's territory is “Gondor”.

*/
begin tran
insert region (RegionID, RegionDescription) values (5, 'Middle Earth')
insert Territories (territoryid, TerritoryDescription, RegionID) values (98105, 'Gondor', 5)
insert employees (lastname, firstname, PostalCode) values ('King','Aragorn',98105)
insert EmployeeTerritories(EmployeeID, territoryid) values (10, 98105)

--Question 2--
/*
Change territory “Gondor” to “Arnor”.
*/
UPDATE Territories SET territorydescription = 'Arnor' where territorydescription = 'Gondor'

--Question 3--
/*
Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget WHERE or you will delete everything.) In case of an error, no changes should be made to DB. Unlock the tables mentioned in question 1.
*/
DELETE FROM Employeeterritories where territoryid = 98105
DELETE FROM Employees where employeeid = 10
DELETE FROM Territories where territorydescription = 'Arnor'
DELETE FROM Region WHERE regiondescription = 'Middle Earth'
rollback

--Question 4--
/*
Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
*/
CREATE VIEW view_product_order_lin AS
SELECT p.productid, p.productname, sum(od.quantity) as totalquantity from products p
inner join [order details] od ON p.productid = od.productid
group by p.productid, p.productname

drop view view_product_order_lin

--Question 5--
/*
Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
*/
CREATE PROCEDURE sp_product_order_quantity_lin (@pid int) AS
SELECT sum(od.quantity) from [order details] od
WHERE od.productid = @pid
GROUP BY od.productid

drop procedure sp_product_order_quantity_lin

--Question 6--
/*
Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
*/
CREATE PROCEDURE sp_product_order_city_lin (@pname varchar(40)) AS
select top 5 c.city, p.productname, sum(od.quantity) from customers c
join orders o ON c.customerid = o.customerid
join [order details] od ON o.orderid = od.orderid
join products p ON od.productid = p.productid
group by p.productname, c.city
having p.productname = @pname

drop procedure sp_product_order_city_lin

--Question 7--
/*
Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored procedure “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”; if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database, and then move those employees to “Stevens Point”.
*/
BEGIN TRAN
CREATE PROCEDURE sp_move_employees_lin AS
IF EXISTS(SELECT * FROM Territories
WHERE territorydescription = 'Tory')
BEGIN
INSERT Territories(TerritoryID, TerritoryDescription, regionid) Values (99999,'Stevens Point', 3) 
UPDATE EmployeeTerritories SET territoryid = 99999 where TerritoryID = 48084
END

select * from Territories

--Question 8--
/*
Create a trigger that when there are more than 100 employees in territory “Stevens Point”, move them back to Troy. (After test your code,) remove the trigger. Move those employees back to “Troy”, if any. Unlock the tables.
*/
CREATE TRIGGER Trg_In_Emp ON Employees
AFTER UPDATE
AS
BEGIN
IF EXISTS (SELECT count(et.territoryid)  FROM Employeeterritories et
where et.TerritoryID = 48084
group by et.territoryid
having count(et.territoryid) > 100)
    BEGIN
    UPDATE EmployeeTerritories SET TerritoryID = 48084 where TerritoryID = 99999
    END
END
drop trigger trg_in_emp
DELETE Territories where territoryid = 99999
rollback

--Question 9--
/*
Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
*/
CREATE TABLE people_lin(id int primary key, pname varchar(100), city int)
CREATE TABLE city_lin(id int primary key, city varchar(20))
INSERT city_lin(id, city) Values (1, 'Seattle')
INSERT city_lin(id, city) Values (2, 'Green Bay')
INSERT people_lin(id,pname,city) Values(1, 'Aaron Rodgers', 2)
INSERT people_lin(id,pname,city) Values(2, 'Russell Wilson', 1)
INSERT people_lin(id,pname,city) Values(3, 'Jody Nelson', 2)
UPDATE city_lin SET city = 'Madison' where id = 1
CREATE VIEW Packers_lin AS
select id, pname from people_lin
where city = 2

Drop View Packers_lin
Drop table people_lin
Drop table city_lin

--Question 10--
/*
Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
*/
CREATE PROCEDURE sp_birthday_employees_lin AS
create table birthday_employees_lin AS
select * from Employees
where month(birthdate) = 2

Drop table birthday_employees_lin
drop procedure sp_birthday_employees_lin

--Question 11--
/*
Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).
*/
CREATE PROCEDURE sp_lin_1 AS
select c.city, count(c.customerid) from customers c
where c.customerid IN
(select c.customerid, count(od.productid) from customers c
inner join orders o ON c.customerid = o.customerid
inner join [order details] od ON o.orderid = od.orderid
group by c.customerid
having count(od.productid) < 2)
group by c.city
having count(c.customerid) > 1

drop procedure sp_lin_1
