USE [sqlDB]
GO
/****** Object:  Trigger [dbo].[trg_backupUsertbl]    Script Date: 2021-02-16 오전 11:41:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[trg_backupUsertbl]
ON [dbo].[userTbl]
AFTER UPDATE, DELETE
AS
	DECLARE @modType nchar(2);
	if (COLUMNS_UPDATED() > 0) -- 업데이트
		BEGIN
			SET @modType = '수정';
		END
	ELSE
		BEGIN
			SET @modType = '수정';
		END

	INSERT INTO backup_usertbl
	SELECT [userID]
      ,[userName]
      ,[birthYear]
      ,[addr]
      ,[mobile1]
      ,[mobile2]
      ,[height]
      ,[mDate]
	  ,@modType
	  ,GETDATE()
	  ,USER_NAME()
	  FROM DELETED;

