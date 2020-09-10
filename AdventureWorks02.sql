/* Comprehensive Questions
1. What is a result set?
Ans: Result set is a set of data, could be empty or not, returned by a select statement, or a stored
procedure, that is saved in RAM or displayed on the screen.

2. What is the difference between Union and Union All?
Ans: UNION removes duplicate records (where all columns in the results are the same), UNION
ALL does not.

3. What are the other Set Operators SQL Server has?
Ans: INTERSECT and EXCEPT.

4. What is the difference between Union and Join?
Ans: UNION combines data into new rows; whereas JOIN combine data into new columns.

5. What is the difference between INNER JOIN and FULL JOIN?
Ans: An INNER JOIN returns only the matched rows; whereas a FULL JOIN returns all rows in both
the left and right tables.

6. What is difference between left join and outer join?
Ans: LEFT JOIN is a type of three OUTER JOIN types (LEFT JOIN, RIGHT JOIN, and FULL JOIN).

7. What is cross join?
Ans: A CROSS JOIN returns the Cartesian product of the sets of records from the two joined tables.

8. What is self join?
Ans: A SELF JOIN is a regular join, but the table is joined with itself.

9. What is the difference between WHERE clause and HAVING clause?
Ans: The HAVING clause is used after the GROUP BY clause. The WHERE clause, in contrast, is used to qualify the rows that are returned before the data is aggregated or grouped.

10. Can there be multiple group by columns?
Ans: Yes. There can be multiple GROUP BY columns.
*/

/* AdventureWorks scenarios */

--Question 1--
/*
How many products can you find in the Production.Product table?
*/
select count(ProductID) from Production.Product
/* ANS: 504 */

--Question 2--
/*
Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
*/
select count(ProductSubcategoryID) from Production.Product
/* ANS: 295 */

--Question 3--
/*
How many Products reside in each SubCategory? Write a query to display the results with the following titles.

ProductSubcategoryID CountedProducts
-------------------- ---------------

*/
select ProductSubcategoryID, count(ProductSubcategoryID) as CountedProducts from Production.Product
group by ProductSubcategoryID

--Question 4--
/*
How many products that do not have a product subcategory. 
*/
select count(ProductID) - count(ProductSubcategoryID) from Production.Product
/* ANS: 209 */

--Question 5--
/*
Write a query to list the summary of products in the Production.ProductInventory table.
*/
select * from Production.ProductInventory
where LocationID=40

--Question 6--
/*
Write a query to list the summary of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.

ProductID    TheSum
---------    ------

*/

select ProductID, sum(Quantity) as TheSum from Production.ProductInventory
where LocationID=40
group by ProductID
having sum(Quantity) < 100

--Question 7--
/*
Write a query to list the summary of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

Shelf      ProductID    TheSum
-----      ---------    ------

*/
select Shelf, ProductID, sum(Quantity) as TheSum from Production.ProductInventory
where LocationID=40
group by ProductID, Shelf
having sum(Quantity) < 100

--Quesiton 8--
/*
Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
*/
select avg(quantity) from Production.ProductInventory
where LocationID=10
/* ANS: 295 */

--Question 9--
/*
Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory

ProductID   Shelf      TheAvg
---------   -----      ------

*/
select Shelf, ProductID, avg(quantity) as TheAvg from Production.ProductInventory
group by Shelf, ProductID

--Question 10--
/*
Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory

ProductID   Shelf      TheAvg
---------   -----      ------

*/
select Shelf, ProductID, avg(quantity) as TheAvg from Production.ProductInventory
where Shelf != 'N/A'
group by Shelf, ProductID

--Question 11--
/*
List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

Color   Class 	TheCount   AvgPrice
-----	----- 	--------   --------

*/
select Color,Class,count(*) as TheCount,avg(ListPrice) as AvgPrice from Production.Product
where Color IS NOT NULL and Class IS NOT NULL
group by Color,Class

--Question 12--
/*
Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. 

Country       Province
-------       --------

*/

select cr.Name as Country,sp.Name as Province from person.CountryRegion cr
join person.StateProvince sp on cr.CountryRegionCode=sp.CountryRegionCode

--Question 13--
/*
Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.

Country       Province
-------       --------

*/
select cr.Name as Country,sp.Name as Province from person.CountryRegion cr
join person.StateProvince sp on cr.CountryRegionCode=sp.CountryRegionCode
where cr.Name='Germany' or cr.Name='Canada'

--Question 14--
/*
List all Products that has been sold at least once in last 25 years.
*/
select p.productid, p.productname, o.OrderDate from Products p
inner join [order details] od ON p.productid = od.productid
inner join orders o ON od.orderid = o.orderid
where o.orderdate >= 1996/01/01

--Question 15--
/*
List top 5 locations (Zip Code) where the products sold most.
*/
select TOP 5 c.postalcode, sum(od.quantity) AS TheSum from customers c
inner join orders o ON c.customerid = o.customerid
inner join [order details] od ON o.orderid = od.orderid
group by c.postalcode

--Question 16--
/*
List top 5 locations (Zip Code) where the products sold most in last 20 years.
*/
select TOP 5 c.postalcode, sum(od.quantity) AS TheSum from customers c
inner join orders o ON c.customerid = o.customerid
inner join [order details] od ON o.orderid = od.orderid
where o.orderdate >= 2000/01/01
group by c.postalcode

--Question 17--
/*
List all city names and number of customers in that city.     
*/
select c.city, count(c.customerid) AS HeadCount from customers c
group by c.city

--Question 18--
/*
List city names which have more than 10 customers, and number of customers in that city 
*/
select c.city, count(c.customerid) AS HeadCount from customers c
group by c.city
having count(c.customerid) > 10

--Question 19--
/*
List the names of customers who placed orders after 1/1/98 with order date.
*/
select c.companyname from customers c
inner join orders o ON c.customerid = o.customerid
where o.orderdate > 1/1/98

--Question 20--
/*
List the names of all customers with most recent order dates 
*/
select c.companyname, max(o.orderdate) as MostRecentOrderDate from customers c
inner join orders o ON c.customerid = o.customerid
group by c.companyname
order by c.companyname

--Question 21--
/*
Display the names of all customers  along with the  count of products they bought 
*/
select c.companyname, sum(od.quantity) AS TheSum from customers c
left join orders o ON c.customerid = o.customerid
left join [order details] od ON o.orderid = od.orderid
group by c.companyname

--Question 22--
/*
Display the customer ids who bought more than 100 Products with count of products.
*/
select c.customerid, sum(od.quantity) AS TheSum from customers c
left join orders o ON c.customerid = o.customerid
left join [order details] od ON o.orderid = od.orderid
group by c.customerid
having sum(od.quantity) > 100

--Quesiton 23--
/*
List all of the possible ways that suppliers can ship their products. Display the results as below

Supplier Company Name   	Shipping Company Name
---------------------           ---------------------

*/

select distinct su.companyname AS [Suppler Compay Name],
sh.companyname AS [Shipping Company Name] from suppliers SU
inner join products p ON su.supplierid = p.supplierid
inner join [order details] od ON p.productid = od.productid
inner join orders o ON od.orderid = o.orderid
inner join shippers sh ON o.shipvia = sh.shipperid
order by sh.companyname, su.companyname

--Question 24--
/*
Display the products order each day. Show Order date and Product Name.
*/
select o.orderdate, p.productname from orders o
inner join [order details] od ON o.orderid = od.orderid
inner join products p ON od.productid = p.productid
order by o.orderdate

--Question 25--
/*
Displays pairs of employees who have the same job title.
*/
select eone.employeeid AS Employee1, etwo.employeeid AS Employee2, eone.title 
from employees eone
inner join employees etwo on eone.title = etwo.title
where eone.employeeid != etwo.employeeid

--Question 26--
/*
Display all the Managers who have more than 2 employees reporting to them.
*/
select etwo.EmployeeID, count(eone.ReportsTo) as TheCount from employees eone
inner join employees etwo on eone.ReportsTo = etwo.EmployeeID
group by etwo.employeeid
having count(eone.reportsto) > 2

--Question 27--
/*
Display the customers and suppliers by city. The results should have the following columns

City 
Name 
Contact Name,
Type (Customer or Supplier)

*/
select c.city as City, c.companyname AS Name, c.contactname as [Contact Name], 'Customer' AS [Type (Customer or Supplier)]
from Customers c
union
select s.city as City, s.companyname AS Name, s.contactname as [Contact Name], 'Supplier' AS [Type (Customer or Supplier)]
from suppliers s
order by c.city