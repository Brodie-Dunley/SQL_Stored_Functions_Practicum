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