CREATE or ALTER Function ufnTotalOrders(@orderdate date)
returns smallint 
AS
BEGIN
	declare @ordercount smallint = 0
	select @ordercount = COUNT(*) FROM Orders
	WHERE OrderDate > @orderdate
	return @ordercount 
END

SELECT dbo.ufnTotalOrders('2022-09-01')

CREATE or ALTER Function ufnTotalOrderPerCustomer(@custid char(5), @orderdate date)
returns smallint 
AS
BEGIN
	declare @ordercount smallint = 0
	select @ordercount = COUNT(*) FROM Orders
	WHERE 
		(OrderDate > @orderdate) AND CustomerID = @custid
	return @ordercount 
END

SELECT dbo.ufnTotalOrderPerCustomer('VINET','2022-09-01')

CREATE or ALTER Function ufnTotalOrderValue(@orderdate date)
returns float 
AS
BEGIN
	declare @orderValue float = 0
	select 
		@orderValue = SUM((UnitPrice * Quantity) * (1-discount)) 
		FROM OrderDetails od
		INNER JOIN Orders o ON od.OrderID = o.OrderID
	WHERE 
		o.OrderDate> @orderdate
	return @orderValue 
END

SELECT dbo.ufnTotalOrderValue('2000-01-01')

CREATE or ALTER Function ufnTotalOrderValuePerCustomer(@custid char(5),@orderdate date)
returns float 
AS
BEGIN
	declare @orderValue float = 0
	select 
		@orderValue = SUM((UnitPrice * Quantity) * (1-discount)) 
		FROM OrderDetails od
		INNER JOIN Orders o ON od.OrderID = o.OrderID
	WHERE 
		o.OrderDate >= @orderdate AND CustomerID = @custid
	return ISNULL (@orderValue,0) 
END

SELECT dbo.ufnTotalOrderValue('2000-01-01')

OR

CREATE or ALTER Function ufnTotalOrderValuePerCustomer(@custid char(5),@orderdate date)
returns float AS
BEGIN
	DECLARE @doesexist smallint
	DECLARE @ordervalue float = -1
	SELECT @doesexist = COUNT(*) FROM customers WHERE customerid = @custid
	IF @doesexist <> 0
		BEGIN
			SELECT @ordervalue = SUM((UnitPrice * Quantity) * (1-discount))  
			FROM OrderDetails od INNER JOIN Orders o ON od.OrderID = o.OrderID
			WHERE o.OrderDate >= @orderdate AND CustomerID = @custid
			SET @ordervalue = ISNULL(@orderValue,0) 
		END	
		return @ordervalue
END

CREATE or ALTER Function ufnNextHighest(@custid char(5), @orderdate date) 
returns char(5)
AS 
BEGIN

DECLARE @foundCust varchar(5);
DECLARE @targetCustVal float = dbo.ufnTotalOrderValuePerCustomer('Anton', '2001-01-01')

SELECT top 1 
	@foundCust = CustomerID
	FROM OrderDetails od
	INNER JOIN Orders o ON od.OrderID = o.OrderID
	Group by CustomerID
	HAVING dbo.ufnTotalOrderValuePerCustomer(CustomerID, @orderdate) < @targetCustVal
	ORDER BY dbo.ufnTotalOrderValuePerCustomer(CustomerID, @orderdate) DESC;
	return @foundCust
END
CREATE or ALTER procedure uspCustomerReport(@custid char(5), @orderdate date)

AS
BEGIN
	declare @customerorderValue float = 0
	declare @customerOrderNum smallint = 0
	declare @totalCompanyValue float = 0
	declare @totalCompanyNum smallint = 0
	declare @customerNumPercent float = 0
	declare @customerValuePercent float = 0
	
	set @customerOrderNum = dbo.ufnTotalOrderPerCustomer(@custid, @orderdate)
	set @customerorderValue = dbo.ufnTotalORderValuePerCustomer(@custid, @orderdate)

	set @totalCompanyValue = dbo.ufnTotalOrderValue(@orderdate)
	set @totalCompanyNum = dbo.ufnTotalOrders(@orderdate)

	set @customerNumPercent = ROUND(((CAST(@customerOrderNum AS FLOAT) / @totalCompanyNum) * 100), 1)

	set @customerValuePercent = ROUND(((@customerorderValue / @totalCompanyValue) * 100),1)

	DECLARE @nextHighestCust varchar(5) 
	set @nextHighestCust = dbo.ufnNextHighest(@custid,@orderdate)

	
	SELECT @custid AS 'Customer Id', @customerOrderNum AS '# of Orders', @customerNumPercent AS ' % of Orders', @customerorderValue AS 'Value', @customerValuePercent AS '% of Total', @nextHighestCust AS 'Next Highest Customer Id'
END