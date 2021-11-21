CREATE DATABASE Library
USE Library

CREATE TABLE Author
(
	Id int IDENTITY Primary KEY,
	Name nvarchar(25),
	Surname nvarchar(25),
)

--drop table Author
--drop table Books

CREATE TABLE Books
(
	Id int IDENTITY Primary KEY,
	Name nvarchar(100) CHECK(LEN(Name)>1),
	AuthorId int,
	PageCount int CHECK(PageCount>9)
)

INSERT INTO Author
VALUES
('George', 'Orivel'),
('Joe', 'Navarro'),
('Feodor', 'Dostoyevski')

INSERT INTO Books
VALUES
('Body Language', 2,350),
('Crime and Punishment', 3,500),
('Animal Farm', 1,70),
('1984', 1,300)

exec sp_rename 'Author', 'Authors'

SELECT * FROM Authors
SELECT * FROM Books

/*SELECT Books.Id,
Books.Name,
Books.PageCount,
Authors.Name+' '+Authors.Surname AS 'AuthorFullName' FROM Books
JOIN Authors ON Books.AuthorId=Authors.Id*/


--1ST TASK
CREATE VIEW VW_BooksDetail
AS
SELECT Books.Id,
Books.Name,
Books.PageCount,
Authors.Name+' '+Authors.Surname AS 'AuthorFullName' FROM Books
JOIN Authors ON Books.AuthorId=Authors.Id

SELECT * FROM VW_BooksDetail

--2ND TASK
CREATE PROCEDURE USP_Search @search nvarchar(50)
AS
SELECT * FROM VW_BooksDetail
WHERE (Name LIKE '%'+@search+'%') OR (AuthorFullName LIKE '%'+@search+'%')

EXEC USP_Search 'OE'


--3RD TASK
--1. Insert Procedure
CREATE PROCEDURE USP_Insert @AName NVARCHAR(50), @ASurname NVARCHAR(50)
AS
INSERT INTO Authors
VALUES
(@AName, @ASurname)

EXEC USP_Insert N'Çingiz','Mustafayev'


--2. Delete Procedure
CREATE PROCEDURE USP_Delete @Id int
AS
DELETE FROM Authors
WHERE Authors.Id = @Id

EXEC USP_Delete 4


--3. Update Procedure
CREATE PROCEDURE USP_UpdateNameAuthor @name nvarchar(25), @id int
as
UPDATE Authors
set Name=@name
where Authors.Id=@id

CREATE PROCEDURE USP_UpdateSurnameAuthor @surname nvarchar(25), @id int
as
UPDATE Authors
set Surname=@surname
where Authors.Id=@Id

EXEC USP_UpdateNameAuthor 'DefaultName', 5
EXEC USP_UpdateSurnameAuthor 'DefSurname', 5


SELECT * FROM Authors


--4th
CREATE VIEW VW_AuthorsDetail
AS
SELECT
Authors.Id,
Authors.Name+' '+Authors.Surname AS 'FullName',
(SELECT COUNT(AuthorId) FROM Books WHERE Authors.Id=AuthorId) AS 'BooksCount',
(SELECT Max(PageCount) FROM Books WHERE Authors.Id=AuthorId) AS 'MaxPageCount'
FROM Authors
WHERE EXISTS (SELECT * FROM Books WHERE Books.AuthorId=Authors.Id)

SELECT * FROM VW_AuthorsDetail

