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
