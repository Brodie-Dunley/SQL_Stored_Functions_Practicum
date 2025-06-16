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