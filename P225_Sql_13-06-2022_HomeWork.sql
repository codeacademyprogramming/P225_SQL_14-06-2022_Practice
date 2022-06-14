--Database Yaradin Adi Ne Olursa Olsun
Create Database P225Store

Use P225Store

--Brands Adinda Table Yaradin  Id ve Name Columlari Olsun.

Create Table Brands
(
	Id int primary key identity,
	Name nvarchar(255) Not Null Unique
)

INSERT INTO Brands
VALUES
('Apple'),
('Hp'),
('Samsung'),
('Xiaomi'),
('Huawei'),
('Asus'),
('Dell')

--Notebooks Adinda Table Yaradin Id,Name, Price Columlari Olsun.

Create Table Notebooks
(
	Id int primary key identity,
	Name nvarchar(255) Not Null Unique,
	Price money
)

--Phones Adinda Table Yaradin Id, Name, Price Columlari Olsun.

Create Table Phones
(
	Id int primary key identity,
	Name nvarchar(255) Not Null Unique,
	Price money
)

--1) Notebook ve Brand Arasinda Mentiqe Uygun Relation Qurun.

Alter Table Notebooks
Add BrandId int Not Null Foreign Key References Brands(Id)

INSERT INTO Notebooks
VALUES
('250 G5', 943, 2),
('250 G6', 1158, 2),
('250 G7', 1251, 2),
('Air', 2363, 1),
('Pro 13', 2975, 1),
('Pro 15', 3439, 1),
('ROG', 2928, 6),
('ROG PRO', 3968, 6),
('VIVOBOOK 15', 1536, 6),
('VIVOBOOK 14', 1325, 6),
('Mate X', 1600, 5),
('Mate X PRO', 1900, 5),
('Mate XL PRO', 1864, 5),
('Mate XXL PRO', 1253, 5),
('Mi Notebook Air', 1753, 4),
('Mi Notebook Pro', 2153, 4),
('Lustrous Grey', 4681, 4),
('Galaxy Book', 1874, 3),
('Galaxy Book PRO', 3274, 3),
('Galaxy Book AIR', 2574, 3),
('Galaxy Book AIR PRO', 3367, 3)

--2) Phones ve Brand Arasinda Mentiqe Uygun Relation Qurun.

Alter Table Phones
Add BrandId int Not Null Foreign Key References Brands(Id)

INSERT INTO Phones
VALUES
('250 G5', 943, 2),
('13', 2463, 1),
('13 Pro', 3075, 1),
('13 Pro Max', 3339, 1),
('Mate Pad', 1600, 5),
('Mate Xs', 1900, 5),
('Nova 9 SE', 1864, 5),
('P50E', 1853, 5),	
('Poco 5', 1753, 4),
('Poco 4', 2153, 4),
('Poco 6', 4681, 4),
('A11', 275, 3),
('A21', 285, 3),
('A31', 374, 3),
('A41', 467, 3),
('A51', 567, 3),
('A61', 667, 3),
('A71', 767, 3),
('A81', 867, 3),
('A91', 967, 3)

--3) Notebooks Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.

Select n.Name, b.Name 'BrandName', n.Price From Notebooks n
Join Brands b On n.BrandId = b.Id

--4) Phones Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.

Select p.Name, b.Name 'BrandName', p.Price From Phones p
Join Brands b On p.BrandId = b.Id

--5) Brand Adinin Terkibinde s Olan Butun Notebooklari Cixardan Query.

Select * From Notebooks Where Exists(Select * From Brands Where Id = Notebooks.BrandId And Name Like '%s%')

--6) Qiymeti 2000 ve 5000 arasi ve ya 5000 den yuksek Notebooklari Cixardan Query.

Select * From Notebooks Where Price Between 2000 And 3000 Or Price > 4000

--7) Qiymeti 1000 ve 1500 arasi ve ya 1500 den yuksek Phonelari Cixardan Query.

Select * From Phones Where Price Between 1000 And 1700 Or Price > 2500

--8) Her Branda Aid Nece dene Notebook Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.

Select b.Name, COUNT(*) 'Count' From Brands b
Join Notebooks n On n.BrandId = b.Id
Group By b.Name

--9) Her Branda Aid Nece dene Phone Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.

Select b.Name, COUNT(*) 'Count' From Brands b
Join Phones p On p.BrandId = b.Id
Group By b.Name

--10) Hem Phone Hem de Notebookda Ortaq Olan Name ve BrandId Datalarni Bir Cedvelde Cixardan Query.

Select Name, BrandId From Notebooks 
Union 
Select Name, BrandId From Phones

--11) Phone ve Notebook da Id, Name, Price, ve BrandId Olan Butun Datalari Cixardan Query.

Select * From Notebooks 
Union All
Select * From Phones

--12) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalari Cixardan Query.

Select products.Id, products.Name,products.Price, b.Name 'BrandName' from
(
	Select * From Notebooks
	Union All
	Select * From Phones
) products
Join Brands b On products.BrandId = b.Id

--13) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalarin Icinden 
--Price 1000-den Boyuk Olan Datalari Cixardan Query.

Select products.Id, products.Name,products.Price, b.Name 'BrandName' from
(
	Select * From Notebooks
	Union All
	Select * From Phones
) products
Join Brands b On products.BrandId = b.Id
Where products.Price > 2000

--14) Phones Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq Brandin Adi (BrandName kimi), 
--Hemin Brandda Olan Telefonlarin Pricenin Cemi (TotalPrice Kimi) ve 
--Hemin Branda Nece dene Telefon Varsa Sayini (ProductCount Kimi) Olan Datalari Cixardan Query.Misal
--BrandName:        TotalPrice:        ProductCount:
--Apple					6750                3
--Samsung				3500                4
--Redmi                 800					1

Select b.Name 'BrandName', SUM(p.Price) 'TotalPrice', COUNT(*) 'ProductCount' From Phones p
Join Brands b On p.BrandId = b.Id
Group By b.Name

Select b.Name 'BrandName', SUM(p.Price) 'TotalPrice', COUNT(*) 'ProductCount', MIN(p.Price) 'Minimum', MAX(p.Price) 'Maximum' From Phones p
Join Brands b On p.BrandId = b.Id
Group By b.Name

--15) Notebooks Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq Brandin Adi (BrandName kimi), 
--Hemin Brandda Olan Telefonlarin Pricenin Cemi (TotalPrice Kimi) , 
--Hemin Branda Nece dene Telefon Varsa Sayini (ProductCount Kimi) Olacaq ve Sayi 3-ve 3-den Cox Olan Datalari Cixardan Query.Misal
--BrandName:        TotalPrice:        ProductCount:
--Apple					6750                3
--Samsung				3500                4
Select b.Name 'BrandName', SUM(n.Price) 'TotalPrice', COUNT(*) 'ProductCount' From Notebooks n
Join Brands b On n.BrandId = b.Id
Group By b.Name
Having COUNT(*) >= 4