/* Short-answer Questions
1. What is an object in SQL?
Ans: A database object is any defined object in a database that is used to store or reference data.
Some examples of database objects include tables, views, clusters, sequences, indexes, and synonyms.

2. What is Index? What are the advantages and disadvantages of using Indexes?
Ans: Indexes are special lookup tables that the database search engine can use to speed up data retrieval.

3. What are the types of Indexes?
Ans: Clustered index and non-clustered index

4. Does SQL Server automatically create indexes when a table is created? If yes, under which constraints?
Ans: Implicit indexes are automatically created by the database server when an object is created.
Indexes are automatically created for primary key constraints and unique constraints.

5. Can a table have multiple clustered index? Why?
Ans: No. Each table has only one clustered index because data rows can be only sorted in one order.

6. Can an index be created on multiple columns? Is yes, is the order of columns matter?
Ans: Yes. Multicolumn indexes can be created on up to 32 columns.
Column order is very important because the second column in a multicolumn index can never be accessed without accessing the first column.

7. Can indexes be created on views?
Ans: Yes. First create a view that uses the WITH SCHEMEBINDING option which binds the view to the schema of the underlying tables.
Second, create a unique clustered index on the view.

8. What is normalization? What are the steps (normal forms) to achieve normalization?
Ans: Data normalization is a process of organizing data to minimize redundancy (data duplication), which in turn ensures data consistency.
Normalization has a series of steps called Forms. The more steps you take the more normalized your tables are.

9. What is denormalization and under which scenarios can it be preferable?
Ans: Denormalization is a strategy used on a previously-normalized database to increase performance.
Denormalization improves the read performance at the expense of losing some write performance,
by adding redundant copies of data or by grouping data.

10. How do you achieve Data Integrity in SQL Server?
Ans: Domain, entity, and referential integrity

11. What are the different kinds of constraint do SQL Server have?
Ans: NOT NULL, Unique, Primary Key, Foreign Key, and Check constraints

12. What is the difference between Primary Key and Unique Key?
Ans: Difference: 
a) There can only be one primary key for a table; whereas there can be multiple unique keys defined on a table
b) The primary key enforces the entity integrity of the table;
c) All columns defined in primary key must be NOT NULL; whereas column may be NULL for unique key, but only one NULL per column is allowed.
d) The primary key uniquely identifies a row; whereas a unique constraint can be referenced by a foreign key constraint
e) Primary keys result in CLUSTERED unique indexes by default; whereas unique keys result in NONCLUSTERED unique indexes by default.

13. What is foreign key?
Ans: A foreign key is a column or combination of columns that is used to establish and enforce a link between the data in two tables.

14. Can a table have multiple foreign keys?
Ans: Yes. A table can have multiple foreign keys.

15. Does a foreign key have to be unique? Can it be null?
Ans: Unlike primary keys, foreign keys can contain duplicate values and it is okay for them to contain NULL values.

16. Can we create indexes on Table Variables or Temporary Tables?
Ans: Yes. You can index a table variable or temporary table implicitly by defining a primary key and creating unique constraints. 

17. What is Transaction? What types of transaction levels are there in SQL Server?
Ans: Transactions are a logical unit of work. Transaction is a single recoverable unit of work that executes either completely or not at all.
Levels: read uncommitted, read committed, repeatable read, snapshot, and serializable.
*/

/* Query questions */

--Question 1--
/*
Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002
*/
--Given--
create table customer(cust_id int primary key, iname varchar(50))
create table order (order_id int primary key, cust_id int foreign key references customer,
amount money, order_date smalldate)

--Response--
select c.cust_id, c.iname, sum(o.amount) from customer c
where date(o.order_date) = 2002
inner join order o ON c.cust_id = o.cust_id
group by c.cust_id

--Question 2--
/*
The following table is used to store information about company’s personnel. Write a query that returns all employees whose last names  start with “A”.
*/
--Given--
create table person(id int primary key, firstname varchar(100), lastname varchar(100))

--Response--
select * from person
where lastname like 'A%'

--Question 3--
/*
The information about company’s personnel is stored in the following table. The filed managed_id contains the person_id of the employee’s manager. Please write a query that would return the names of all top managers(an employee who does not have  a manger, and the number of people that report directly to this manager.
*/
--Given--
create table person(perdon_id int primary key, manager_id int null, name varchar(100) not null)

--Response--
select p1.person_id, p1.name, count(p2.manager_id) AS NumOfSubordinates from person p1
where p1.manager_id IS NULL
inner join person p2 ON p1.person_id = p2.manager_id
group by p1.person_id

--Question 4--
/*
List all events that can cause a trigger to be executed.
Ans:
DML statments: INSERT, UPDATE, DELETE
DDL statments
system events: startup, shutdown, error messages
*/

--Question 5--
/*
Generate a destination schema in 3rd Normal Form.  Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  The following assumptions can be made:
a. Each Company can have one or more Divisions.
b. Each record in the Company table represents a unique combination 
c. Physical locations are associated with Divisions.
d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
e. Contacts can be associated with one or more divisions and the address, but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.

*/
create table company(cid  int primary key, companyname varchar(50), location = varchar(100))
create table division(cid int foreign key references company, did int, dname = varchar(50), location = varchar(100), primary key (cid, did))
create table contact (contactid = int primary key, contactname = varchar(50), did int, suite int, maildrop = int)