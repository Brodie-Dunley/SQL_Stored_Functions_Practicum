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
