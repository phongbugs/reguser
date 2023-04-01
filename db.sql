CREATE TABLE [dbo].[Account_Info] (
	[iid] [bigint] IDENTITY (1, 1) NOT NULL ,
	[cAccName] [varchar] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[cPassWord] [varchar] (99) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[cSecPassword] [varchar] (99) COLLATE Chinese_PRC_CI_AS NULL ,
	[cRealName] [varchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[dBirthDay] [datetime] NULL ,
	[cArea] [varchar] (60) COLLATE Chinese_PRC_CI_AS NULL ,
	[cIDNum] [varchar] (30) COLLATE Chinese_PRC_CI_AS NULL ,
	[dRegDate] [datetime] NULL ,
	[cPhone] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[iClientID] [bigint] NULL ,
	[dLoginDate] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[dLogoutDate] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[iTimeCount] [tinyint] NULL ,
	[cQuestion] [varchar] (250) COLLATE Chinese_PRC_CI_AS NULL ,
	[cAnswer] [varchar] (250) COLLATE Chinese_PRC_CI_AS NULL ,
	[cSex] [varchar] (4) COLLATE Chinese_PRC_CI_AS NULL ,
	[cDegree] [varchar] (16) COLLATE Chinese_PRC_CI_AS NULL ,
	[cEMail] [varchar] (128) COLLATE Chinese_PRC_CI_AS NULL ,
	[iLock] [int] NULL ,
	[gCode] [int] NULL 
) ON [PRIMARY]
GO

------ STORE PROCEDURE ------

CREATE PROCEDURE _spListAllUsername
AS
SELECT cAccName FROM Account_Info
GO

CREATE PROCEDURE _spCreateUser
@username VARCHAR(50),
@password VARCHAR(50)
AS
INSERT INTO Account_Info(cAccName, cPassWord)
VALUES (@username, @password);
GO