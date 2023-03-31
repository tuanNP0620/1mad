--1
select* from Person.Person
--2
select Title,FirstName,MiddleName from Person.Person
--3
select CONCAT(Title,FirstName,MiddleName) as PersonName from Person.Person
--4
select * from Person.Address
select distinct City from Person.Address
select * into cityindex from Person.Address--Tạo bảng mới có tên cityindex

CREATE INDEX idcityindex ON cityindex(City)--đánh chỉ số index cho trường city
--5
select distinct City from cityindex--truy vấn trong bảng có đánh chỉ số
--6
select top(10) * from Person.Address
--7
select avg(Rate) from HumanResources.EmployeePayHistory
--8
select sum(BusinessEntityID) from HumanResources.Employee
--9:Đề bài ko nói rõ tên bảng
--10:Đề bài ko nói rõ tên bảng
--11
--Câu 4 tạo bảng mới có tên cityindex gồm các trường dữ liệu của bảng Person.Address,sau đó tạo chỉ mục có tên idcityindex trên trường City
--Câu lệnh thứ 1 chiếm 82% tổng chi phí trong khi câu lệnh sử dụng index chỉ chiếm 18% chi phí,nhanh gấp 4,5 lần