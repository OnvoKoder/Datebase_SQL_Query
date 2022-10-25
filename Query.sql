--Find sum order and quantity order per month
select dateadd(month,(datediff(month,0,OrderDate)),0), sum(SubTotal), count(SubTotal) from [AdventureWorks2016].[Sales].[SalesOrderHeader] 
group by dateadd(month,(datediff(month,0,OrderDate)),0)
order by dateadd(month,(datediff(month,0,OrderDate)),0) asc
--Find 10 cities which city biggest quantity order 
select top 10 City, count(City) AS 'Count Order' from [AdventureWorks2016].[Person].[Address] 
group by City 
order by count(City) desc
--Find customers who buy more than 15 same product 
select  person.FirstName, person.LastName,product.[Name] 'Name product', count(product.[Name]) 'Count purchasing product'
  from [AdventureWorks2016].[Production].[Product] product
  join  [AdventureWorks2016].[Sales].[SalesOrderDetail] sod  on product.ProductID = sod.ProductID 
  join [Sales].[SalesOrderHeader] soh on sod.SalesOrderID=soh.SalesOrderID
  join [Sales].[Customer] customer on customer.CustomerID=soh.CustomerID
  join [AdventureWorks2016].[Person].[Person]  person on person.BusinessEntityID = soh.CustomerID 
  group by person.FirstName, person.LastName,product.[Name]
  having count(product.[Name])>15
  order by  FirstName asc, LastName asc 
--Find customers and their order details such as: date of order,quantity and name product
select salesOrderHead.[OrderDate] as 'Date Of Order',person.[LastName] as 'Lastname Customer', person.[FirstName] as 'Firstname Customer', product.[Name] +' Quantity: '+cast(salesOrderDetail.[OrderQty] as varchar(2))+' pieces' as 'Order details'from [Sales].[Customer] customer join [Person].[Person] person on customer.[PersonID]=person.[BusinessEntityID]
join  [Sales].[SalesOrderHeader] salesOrderHead on salesOrderHead.[CustomerID]=customer.[CustomerID]
join [Sales].[SalesOrderDetail] salesOrderDetail on salesOrderHead.[SalesOrderID]=salesOrderDetail.[SalesOrderID]
join [Production].[Product] product on product.[ProductID]=salesOrderDetail.[ProductID]
order by salesOrderHead.[OrderDate] desc
--Find employee and their manager who younnger than employees or work there less employees 
select person.[LastName]+' '+Left(person.[FirstName],1)+'.' +Left(person.[MiddleName],1) +'.' as 'Fullname employee',
employee.[HireDate], employee.[BirthDate],
persons.[LastName]+' '+Left(persons.[FirstName],1)+'.' +Left(persons.[MiddleName],1) +'.' as 'Fullname employer',
manager.[HireDate], manager.[BirthDate]
 from [HumanResources].[Employee] employee
join [Person].[Person]  person on employee.[BusinessEntityID]=person.[BusinessEntityID]
right join [HumanResources].[Employee] manager on manager.[BusinessEntityID]=(employee.[BusinessEntityID]+1)
join [Person].[Person]  persons on manager.[BusinessEntityID]=persons.[BusinessEntityID]
where employee.[BirthDate]<manager.[BirthDate] or employee.[HireDate]<manager.[HireDate]
order by employee.[OrganizationLevel] asc,
persons.[LastName]+' '+Left(persons.[FirstName],1)+'.' +Left(persons.[MiddleName],1) +'.' asc,
person.[LastName]+' '+Left(person.[FirstName],1)+'.' +Left(person.[MiddleName],1) +'.' asc
--Create function that has two parameters: the first date of birth and the second date of birth. Function allows tou to find number of male employees, single and born between two parameters 
create function FindQuantityEmployee (@FirstDateBirth date, @SecondDateBirth date)
returns int
as begin
declare @count int
set @count=(select count(*) from [HumanResources].[Employee] where MaritalStatus='S' and Gender='M' and BirthDate between @FirstDateBirth and @SecondDateBirth)
return @count
end;
--test function
select  [dbo].[FindQuantityEmployee]('1970.01.01', '1974.01.01')