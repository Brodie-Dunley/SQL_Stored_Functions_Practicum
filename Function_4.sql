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