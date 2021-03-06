USE [sqlDB]
GO
/****** Object:  StoredProcedure [dbo].[usp_users]    Script Date: 2021-02-15 오후 2:11:56 ******/

CREATE OR ALTER PROCEDURE [dbo].[usp_users]
	@birthYear int,
	@height smallint
AS
	SELECT *
	FROM userTBL
	WHERE birthYear > @birthYear AND height > @height;
GO

exec dbo.usp_users 1970, 170;

CREATE OR ALTER PROCEDURE [dbo].[usp_users2]
	@txtValue nvarchar(20),
	@outValue int output -- 리턴받는 매개변수(파라미터)
AS
	INSERT INTO testTBL2 VALUES (@txtValue);
	SELECT @outValue = IDENT_CURRENT('testTBL2'); -- testTBL의 현재 identity값 리턴
GO

DECLARE @myValue int;
exec dbo.usp_users2 '테스트값 1', @myValue output;

PRINT CONCAT('현재 입력된 값은 => ', @myValue);
SELECT @myValue;