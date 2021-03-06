Create Database AttendanceLogger
Go

USE [AttendanceLogger]
GO
/****** Object:  Table [dbo].[Datalogger]    Script Date: 12/25/2021 12:59:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Datalogger](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Logtime] [datetime] NOT NULL,
 CONSTRAINT [PK_Datalogger] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedTableType [dbo].[Tbl_Datalogger]    Script Date: 12/25/2021 12:59:06 ******/
CREATE TYPE [dbo].[Tbl_Datalogger] AS TABLE(
	[BranchId] [bigint] NULL,
	[Machine] [varchar](20) NULL,
	[UserId] [bigint] NULL,
	[Logtime] [datetime] NULL
)
GO
/****** Object:  Table [dbo].[MST_Branchmaster]    Script Date: 12/25/2021 12:59:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MST_Branchmaster](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_MST_Branchmaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[IU_Datalogger]    Script Date: 12/25/2021 12:59:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[IU_Datalogger]
@BranchId as Bigint = NULL,
@DetailTb Tbl_Datalogger READONLY ,  
@result varchar(200) Output
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN A 
			BEGIN
				
				Declare @LastLogDate as Datetime = NULL
				Select @LastLogDate = Max(Logtime) 
				From Datalogger a
				Where a.BranchId = @BranchId  
				
				Insert Into Datalogger ( BranchId , UserId , Logtime ) 
				Select a.BranchId , a.UserId , a.LogTime  
				From @DetailTb a
		 		Where a.LogTime > Isnull(@LastLogDate,'1990-01-01') 
				
				SELECT @result= convert(varchar,@@ROWCOUNT)
			END 
		COMMIT TRAN A 
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN A 
		SeLect @result = null; 
	END CATCH 
END
GO
