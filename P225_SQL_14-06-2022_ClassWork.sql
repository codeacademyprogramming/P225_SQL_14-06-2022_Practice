--Kitabxana database-i qurursunuz
Create Database LibraryDb

Use LibraryDb

--Books (Id, Name, PageCount)
--Books-un Name columu minimum 2 simvol maksimum 100 simvol deyer ala bileceyi serti olsun.
--Books-un PageCount columu minimum 10 deyerini ala bileceyi serti olsun.

Create Table Books
(
	Id int primary key identity,
	Name nvarchar(100) Check(Len(Name) >= 2),
	PageCount int Check(PageCount >= 10)
)

--Authors (Id, Name, Surname)

Create Table Authors
(
	Id int primary key identity,
	Name nvarchar(255),
	SurName nvarchar(255)
)

--Books ve Authors table-larinizin mentiqi uygun elaqesi olsun.

Alter Table Books
Add AuthorId int Foreign Key References Authors(Id)

--Id, Name, PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin

Create View usv_BookDetails
As
Select b.Id, b.Name, b.PageCount, (a.Name+' '+a.SurName) 'AuthorFullName' From Books b
Join Authors a On b.AuthorId = a.Id

Select * From usv_BookDetails

--Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya 
--authorFullNamelerinde olan Book-lari Id, Name, PageCount, AuthorFullName columnlari seklinde gostern procedure yazin

Create Procedure usp_SearchBook
@search nvarchar(255)
As
Begin
	Select * From usv_BookDetails Where Name Like '%'+@search+'%' Or AuthorFullName Like '%'+@search+'%'
End

exec usp_SearchBook 'test'

--Authors tableinin insert, update ve deleti ucun (her biri ucun ayrica) procedure yaradin

Create Procedure usp_CreateAuthor
@name nvarchar(255),
@surname nvarchar(255)
As
Begin
	Insert Into Authors(Name,SurName)
	Values
	(@name,@surname)
End

exec usp_CreateAuthor 'Viktor','Hugo'

Create Procedure usp_UpdateAuthor
@id int,
@name nvarchar(255),
@surname nvarchar(255)
As
Begin
	Update Authors Set Name = @name, SurName = @surname Where Id = @id
End

exec usp_UpdateAuthor 2,'Viktor','Hugo'

Create Procedure usp_DeleteAuthor
@id int
As
Begin
	Delete From Authors Where Id = @id
End

exec usp_DeleteAuthor 3

--Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz Id-author id-si, 
--FullName - Name ve Surname birlesmesi, BooksCount - Hemin authorun elaqeli oldugu kitablarin sayi, 
--MaxPageCount - hemin authorun elaqeli oldugu kitablarin icerisindeki max pagecount deyeri

Create View usv_Authorsdetails
As
Select a.Id, (a.Name+' '+a.SurName) 'FullName', COUNT(*) 'BooksCount', MAX(b.PageCount) 'MaxPageCount' From Authors a
Join Books b On b.AuthorId = a.Id
Group By a.Id, a.Name, a.SurName

Select Id, FullName From usv_Authorsdetails

exec sp_rename 'Authors.Ad','Name'