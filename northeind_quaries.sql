use northwinds;


# Sql commands
# ddl- data Defination languge-create,Drop,alter,Truncate,Rname,etc..
# DML- Data MAnipulation Languge - insert,update,delete,Call,lock,etc..
# TCL- Trasaction control language- commit,Savepoint,Roll Back,Set constraint
# DCl- Data Control Language- Grant, Revoke

# Data Analyst & Data scientist-DQL
# select,from,joins,where, groupby,havingselect,orderby,limit

select*from orders;
select*from `order details`;
select*from employees;

# create a new variable called sales 
#Sales(formula) = ( unit_price * quantity )* ( 1 - discount) 
# 1) Alter table table_name addcolumn colname varchar(8)
# 2) Update tablename Formula;

alter table `order details` add  Sales varchar(8);
set	SQL_SAFE_UPDATES=0;
update `order details` set Sales =(UnitPrice*Quantity)*(1-Discount);

select	min(Sales),max(Sales) from `order details`;

# Categorywise Sales 
# Join three tables, Categories, products, order details.alter
# natural join - automatically identifies the column and joins
# join using (columnsname) 
select CategoryName, round(sum(Sales),2) as TotalSales from
 `order details` natural join products
 natural join categories
 group by CategoryName order by TotalSales desc;
 
 #JOIN using () 
select CategoryName, round(sum(Sales),2) as TotalSales from
 `order details` join products using (ProductID)
 join categories using (CategoryID)
group by CategoryName order by TotalSales desc;

#Country Wise TotalSales - Country from customers table.
#join order details , orders customers

select Country, round(sum(Sales),2) as TotalSales from
`order details` natural join orders
natural join customers
group by Country order by TotalSales desc;

#Employee wise Total Sales.
select concat(firstName," ",lastname) as Empname, round(sum(sales),2) as TotalSales from
`order details` natural join orders
natural join employees
group by Empname order by TotalSales desc;

#productname wise TotoalSales
select ProductName, round(sum(sales),2) as TotalSales from 
`order details` natural join products
group by ProductName order by TotalSales desc limit 10;

#Date Functions - year() month() quarter() 
#dATE FORMAT - "YYYY-MM-DD  HH:MM:SS"
# using shipping Data - Year wise total Sales

select year(ShippedDate) as year, round(sum(sales),2) as
TotalSales from `order details` 
natural join orders
group by Year;

#yearwise monthwise totalsales

select year(ShippedDate) as year, month(ShippedDate) as month,
round(sum(sales),2) as
TotalSales from `order details` 
natural join orders
group by Year,Month;

#Year & CategoryName wise Total sales

select year(ShippedDate) as year, CategoryName,
round(sum(sales),2) as
TotalSales from `order details` 
natural join orders
natural join products
natural join categories
group by Year,CategoryName;

#Which Contry is in Top Sales in year 1996

select year(ShippedDate) as year, Country,
round(sum(sales),2) as TotalSales from `order details` 
natural join orders
natural join customers
where year(ShippedDate)=1996
group by Year,Country order by TotalSales desc
limit 5;

#Country CategoryName  TotalSales

select  Country,CategoryName ,
round(sum(sales),2) as TotalSales from `order details` 
natural join orders
natural join customers
natural join products
natural join categories
group by CategoryName,Country order by TotalSales desc ;

#CategoryName Wise Sale for Germany

select  Country,CategoryName ,
round(sum(sales),2) as TotalSales from `order details` 
natural join orders
natural join customers
natural join products
natural join categories
where country = 'Germany'
group by CategoryName,Country order by TotalSales desc;

# Top 10 Countries in TotalSales CategoryName Seafood

select  CategoryName ,Country,
round(sum(sales),2) as TotalSales from `order details` 
natural join orders
natural join customers
natural join products
natural join categories
where  CategoryName= 'Seafood'
group by CategoryName,Country order by TotalSales desc
limit 10;

# Top 10 most expensive productname in terms of unit price.

select distinct ProductName,UnitPrice from `order details` 
natural join products
order by UnitPrice desc limit 10;

# bottom 10 most expensive productname in terms of unit price.

select distinct ProductName,UnitPrice from  `order details`
natural join products
order by UnitPrice asc limit 10;

#;Top10 Expensice ProductNAme in CategoryName Beverages
select distinct ProductName,CategoryName,UnitPrice from `order details`
natural join products 
natural join categories
order by UnitPrice desc limit 10;

#Employeewise Totalales in CategoryName 'SeaFood'

select distinct EmployeeID,CategoryName,round(sum(Sales),2) as TotalSales from `order details`
natural join products 
natural join categories
natural join employees
where CategoryName='seafood' 
group by employeeid
order by TotalSales desc ;

#country wise count of orders

select country,count(distinct OrderID) as TotalOrders from Orders 
natural join customers
group by country order by Totalorders desc;

#Yearwise Monthwise Count of Orders

select year(ShippedDate) as year,month(ShippedDate) as months,count(distinct OrderID) as TotalOrders from Orders 
natural join `order details`
natural join products
group by year,months
order by TotalOrders desc;



# CategoryName wise Count of Orders

select categoryname,count(distinct OrderID) as TotalOrders from Orders 
natural join `order details`
natural join products
natural join categories
group by categoryname
order by TotalOrders desc;


# Employee wise Count of Orders

select concat(firstname,' ',lastname) as employeename,count(distinct OrderID) as TotalOrders from Orders 
natural join `order details`
natural join employees
group by employeename
order by TotalOrders desc;

# ProductName wise Count of Orders

select ProductName,count(distinct OrderID) as TotalOrders from Orders 
natural join `order details`
natural join products
group by ProductName
order by TotalOrders desc;


# CountryWise CategoryName wise Count of Orders

select CategoryName,Country,count(distinct OrderID) as TotalOrders from Orders 
natural join `order details`
natural join customers
natural join categories
natural join products
group by CategoryName,Country
order by TotalOrders desc;

#create a new variable called purchases.
# Purchases = UnitPrice*(UnitsInStock + UnitsOnOrder)

alter table products drop purchase;
alter table products add purchases decimal(12,2);
set sql_safe_updates=0;
update products set Purchases = UnitPrice*(UnitsInStock + UnitsOnOrder);

select min(purchases),max(purchases),avg(purchases) from products;

# Yearwise purchases

select year(ShippedDate) as year, round(sum(purchases)) as totalpurchases from products
natural join orders
natural join `order details`
group by year
order by totalpurchases desc;

#Yearwise categoryName wise Purchases

select year(ShippedDate) as year,categoryname, round(sum(purchases)) as totalpurchases from products
natural join orders
natural join categories
natural join `order details`
group by year, categoryname
order by totalpurchases desc;


#Country wise Purchases - (use suppliers Table)

select country, round(sum(purchases)) as totalpurchases from products
natural join orders
natural join suppliers
group by country
order by totalpurchases desc;


#top 10 citywise purchases - (use suppliers Table)

select city, round(sum(purchases)) as totalpurchases from products
natural join suppliers
group by city
order by totalpurchases desc limit 10;

#top 10 companyName purchases - (use suppliers Table)

select companyname,Country, round(sum(purchases)) as totalpurchases from products
natural join suppliers
group by companyname,Country
order by totalpurchases desc limit 10;

#top 10 productname purchases - (use suppliers Table)

select productname, round(sum(purchases)) as totalpurchases from products
natural join suppliers
group by ProductName
order by totalpurchases desc limit 10;

#top 20 customer, companyname,city,country in category beverages

select CategoryName,companyname,city,country,round(sum(sales)) as totalsales from `order details`
natural join orders
natural join customers
natural join categories
natural join products
where categoryname='beverages'
group by CategoryName,companyname,city,country
order by totalsales desc limit 20;

#top 10 supliers, companyname,city,country in category beverages

select CategoryName,companyname,city,country,round(sum(purchases)) as totalpurchases from `order details`
natural join orders
natural join suppliers
natural join categories
natural join products
where categoryname='dairy products'
group by CategoryName,companyname,city,country
order by totalpurchases desc limit 10;

#top 10 PRODUCTNAME, companyname,city,country in category beverages

select distinct ProductName,CategoryName, sales from `order details`
natural join products
natural join categories
where sales > 5000
order by sales desc limit 10;

#subqueries - Large Scale Databases
# subqueries written inside Select, update, insert, delete
#operators like In,not in comparision operators >,<,=, any,all,etc.

#productNames, whose sales greater than average sales.

select distinct ProductName, sales from `order details`
natural join products
where sales >(select avg(sales) from `order details`)
order by sales desc ;

#PRODUCT Names whose sales greater than average sales within each category

select distinct ProductName,categoryname, sales from `order details`
natural join products
natural join categories
where sales >=all(select avg(sales) from `order details` where CategoryName='Beverages' group by ProductName,CategoryName);

Select distinct ProductName, Categoryname, sales from `order details` 
natural join products
natural join categories
where Sales >(Select avg(sales) from `order details` 
group by CategoryName) order by sales desc;


 Select distinct ProductName, Categoryname, sales from `order details` 
natural join products
natural join categories
where CategoryName in (select CategoryName from categories
where CategoryName like 'beverages%')
and sales>(select avg(sales) from `order details`);

#customers who has highest sales (company name) in each categoryname

select companyName, categoryname, sales from `order details`
natural join orders natural join customers 
natural join products natural join categories
where sales in (select max(sales) from `order details` group by CategoryName);   

# single row subquries =,<,>,<=,>=,<>,!=
# multiple row subquries in , any, all
