SELECT Customers.CustomerId, Customers.Name, Customers.Email, Customers.Phone, Customers.Address, 
       Company.OrderId, Company.ProductId
FROM Customers
INNER JOIN Company ON Customers.CustomerId = Company.CustomerId;
