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