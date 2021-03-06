USE [master]
GO
/****** Object:  Database [BookReviewDb]    Script Date: 12/12/2015 10:06:23 AM ******/
IF EXISTS
   (SELECT name FROM sys.Databases WHERE name='BookReviewDB')
BEGIN
DROP DATABASE BookReviewDb
END
GO
CREATE DATABASE [BookReviewDb]

GO
USE [BookReviewDb]
GO
/****** Object:  User [ReviewerUser]    Script Date: 12/12/2015 10:06:23 AM ******/
CREATE USER [ReviewerUser] FOR LOGIN [ReviewerLogIn] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [GeneralUser]    Script Date: 12/12/2015 10:06:23 AM ******/
CREATE USER [GeneralUser] FOR LOGIN [GeneralLogIn] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [ReviewerRole]    Script Date: 12/12/2015 10:06:23 AM ******/
CREATE ROLE [ReviewerRole]
GO
/****** Object:  DatabaseRole [GeneralRole]    Script Date: 12/12/2015 10:06:23 AM ******/
CREATE ROLE [GeneralRole]
GO
ALTER ROLE [ReviewerRole] ADD MEMBER [ReviewerUser]
GO
ALTER ROLE [GeneralRole] ADD MEMBER [GeneralUser]
GO
/****** Object:  UserDefinedFunction [dbo].[fx_GetSeed]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fx_GetSeed]()
returns int
As
Begin
Declare @dateconcat nvarchar(20)
Declare @hour nchar(2)
Declare @minute nchar(2)
Declare @second nchar(2)
Declare @millesecond nchar(3)

Set @hour=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@Hour)<2) set @hour=@hour + '0'

Set @minute=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@minute)<2) set @minute=@minute + '0'

Set @second=Cast(DatePart(hour, GetDate()) as nchar(2))
if (len(@second)<2) set @second=@second + '0'

set @millesecond=Cast(Datepart(ms,GetDate())as nchar(3))

set @DateConcat=@hour+@minute+@second+@millesecond
return cast(@DateConcat as int)
End
GO
/****** Object:  UserDefinedFunction [dbo].[fx_HashPassword]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create function [dbo].[fx_HashPassword]
(@seed int, @password nvarchar(50))
returns varbinary(500)
As
Begin
Declare @ToHash nvarchar(70)
Set @ToHash=@password + cast(@seed as nvarchar(20))
Declare @hashed varbinary(500)
set @hashed=hashbytes('sha2_512',@ToHash)
return @hashed
End

GO
/****** Object:  Table [dbo].[Author]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Author](
	[AuthorKey] [int] IDENTITY(1,1) NOT NULL,
	[AuthorName] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AuthorKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AuthorBook]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthorBook](
	[BookKey] [int] NOT NULL,
	[Authorkey] [int] NOT NULL,
 CONSTRAINT [PK_BookAuthor] PRIMARY KEY CLUSTERED 
(
	[BookKey] ASC,
	[Authorkey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Book]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookKey] [int] IDENTITY(1,1) NOT NULL,
	[BookTitle] [nvarchar](255) NOT NULL,
	[BookEntryDate] [datetime] NOT NULL DEFAULT (getdate()),
	[BookISBN] [nvarchar](13) NULL,
PRIMARY KEY CLUSTERED 
(
	[BookKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BookCategory]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookCategory](
	[CategoryKey] [int] NOT NULL,
	[BookKey] [int] NOT NULL,
 CONSTRAINT [PK_BookCategory] PRIMARY KEY CLUSTERED 
(
	[CategoryKey] ASC,
	[BookKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryKey] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CheckinLog]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckinLog](
	[CheckInLogKey] [int] IDENTITY(1,1) NOT NULL,
	[ReviewerKey] [int] NOT NULL,
	[CheckinDateTime] [datetime] NOT NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[CheckInLogKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Review]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[ReviewKey] [int] IDENTITY(1,1) NOT NULL,
	[BookKey] [int] NOT NULL,
	[ReviewerKey] [int] NOT NULL,
	[ReviewDate] [date] NOT NULL DEFAULT (getdate()),
	[ReviewTitle] [nvarchar](255) NULL,
	[ReviewRating] [int] NOT NULL,
	[ReviewText] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Reviewer]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Reviewer](
	[ReviewerKey] [int] IDENTITY(1,1) NOT NULL,
	[ReviewerUserName] [nvarchar](255) NOT NULL,
	[ReviewerFirstName] [nvarchar](255) NULL,
	[ReviewerLastName] [nvarchar](255) NOT NULL,
	[ReviewerEmail] [nvarchar](255) NOT NULL,
	[ReviewerKeyCode] [int] NOT NULL,
	[ReviewPlainPassword] [nvarchar](255) NOT NULL,
	[ReviewerHashedPass] [varbinary](500) NOT NULL,
	[ReviewerDateEntered] [date] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[ReviewerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Author] ON 

GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (1, N'David Foster Wallace')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (2, N'Michel Foucault')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (3, N'Jon Duckett')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (4, N'Brian Green')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (5, N'Pablo Neruda')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (6, N'KIm Stanley Robinson')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (7, N'Don Delilo')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (8, N'Gilles Delueze')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (9, N'Felix Guattari')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (10, N'Neil Young')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (11, N'Neil Gaiman')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (12, N'Samuel Becket')
GO
INSERT [dbo].[Author] ([AuthorKey], [AuthorName]) VALUES (13, N'Peter Sloterdijk')
GO
SET IDENTITY_INSERT [dbo].[Author] OFF
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (1, 8)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (1, 9)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (2, 7)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (3, 3)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (4, 4)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (5, 5)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (6, 6)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (7, 1)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (8, 12)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (9, 11)
GO
INSERT [dbo].[AuthorBook] ([BookKey], [Authorkey]) VALUES (10, 13)
GO
SET IDENTITY_INSERT [dbo].[Book] ON 

GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (1, N'What is Philosophy', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'0231079893')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (2, N'Underworld', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'0965664120')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (3, N'JavaScript and JQuery', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'9781118531648')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (4, N'The elegant Universe', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'0965088806')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (5, N'All the Odes', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'9780374115289')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (6, N'Shaman', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'9781841499994')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (7, N'Infinite Jest', CAST(N'2015-10-11 16:02:13.417' AS DateTime), N'0316066524')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (8, N'How it is', CAST(N'2015-12-02 12:53:51.400' AS DateTime), N'100000000')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (9, N'Neverwhere', CAST(N'2015-12-02 13:02:12.770' AS DateTime), N'9780062371058')
GO
INSERT [dbo].[Book] ([BookKey], [BookTitle], [BookEntryDate], [BookISBN]) VALUES (10, N'Globes', CAST(N'2015-12-02 13:27:45.363' AS DateTime), N'1000000001')
GO
SET IDENTITY_INSERT [dbo].[Book] OFF
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (1, 2)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (1, 5)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (1, 7)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (2, 6)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (9, 5)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (14, 4)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (20, 1)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (25, 10)
GO
INSERT [dbo].[BookCategory] ([CategoryKey], [BookKey]) VALUES (26, 3)
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (1, N'Fiction')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (2, N'Science Fiction')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (3, N'Fantasy')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (4, N'Romance')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (5, N'Classic')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (6, N'Romance')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (7, N'Young Adult')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (8, N'Horror')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (9, N'Poetry')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (10, N'History')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (11, N'Biography')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (12, N'Graphic Novel')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (13, N'Myth')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (14, N'Science')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (15, N'Socialology')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (16, N'Economics')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (17, N'Travel')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (18, N'Self Help')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (19, N'Psychology')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (20, N'Philosophy')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (21, N'Music')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (22, N'Film')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (23, N'Television')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (24, N'Politics')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (25, N'Language')
GO
INSERT [dbo].[Category] ([CategoryKey], [CategoryName]) VALUES (26, N'technology')
GO
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[CheckinLog] ON 

GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1, 3, CAST(N'2015-11-14 11:05:53.743' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (2, 3, CAST(N'2015-11-14 11:13:55.390' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (3, 3, CAST(N'2015-11-14 11:23:02.197' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (4, 3, CAST(N'2015-11-14 11:29:57.633' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (5, 3, CAST(N'2015-11-14 11:38:42.860' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (6, 3, CAST(N'2015-11-14 12:09:58.030' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (7, 4, CAST(N'2015-11-14 13:29:40.160' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1004, 3, CAST(N'2015-12-01 15:00:14.880' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1005, 3, CAST(N'2015-12-01 15:07:31.123' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1006, 2, CAST(N'2015-12-01 15:22:25.990' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1007, 2, CAST(N'2015-12-01 15:23:47.420' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1008, 2, CAST(N'2015-12-02 12:50:42.223' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1009, 2, CAST(N'2015-12-02 12:57:43.770' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1010, 2, CAST(N'2015-12-02 13:01:54.333' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1011, 2, CAST(N'2015-12-02 13:03:59.250' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1012, 2, CAST(N'2015-12-02 13:09:30.210' AS DateTime))
GO
INSERT [dbo].[CheckinLog] ([CheckInLogKey], [ReviewerKey], [CheckinDateTime]) VALUES (1013, 2, CAST(N'2015-12-02 13:26:50.960' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[CheckinLog] OFF
GO
SET IDENTITY_INSERT [dbo].[Review] ON 

GO
INSERT [dbo].[Review] ([ReviewKey], [BookKey], [ReviewerKey], [ReviewDate], [ReviewTitle], [ReviewRating], [ReviewText]) VALUES (1, 6, 1, CAST(N'2015-11-07' AS Date), N'Robinson''s Shaman', 5, N'This book is an amazing recreation of life in the paleolithic')
GO
INSERT [dbo].[Review] ([ReviewKey], [BookKey], [ReviewerKey], [ReviewDate], [ReviewTitle], [ReviewRating], [ReviewText]) VALUES (2, 6, 2, CAST(N'2015-11-07' AS Date), N'Shamen, a tale of the palelithic', 4, N'A fun read. This may not be the way the palelithic was, but it is the way it should have been.')
GO
INSERT [dbo].[Review] ([ReviewKey], [BookKey], [ReviewerKey], [ReviewDate], [ReviewTitle], [ReviewRating], [ReviewText]) VALUES (3, 6, 3, CAST(N'2015-12-01' AS Date), N'Science Fiction about the ancient past', 4, N'Overall this is an excellent book, a riveting story about a boy destined to be a shaman whether he wants to or not. Vividly evokes life on the edge of the slowly receding glaciers.')
GO
INSERT [dbo].[Review] ([ReviewKey], [BookKey], [ReviewerKey], [ReviewDate], [ReviewTitle], [ReviewRating], [ReviewText]) VALUES (6, 1, 2, CAST(N'2015-12-02' AS Date), N'Globalization writ big', 5, N'The second volume of a major philosophical trilogy. This volume expands the personal bubble to the encompassing globe')
GO
SET IDENTITY_INSERT [dbo].[Review] OFF
GO
SET IDENTITY_INSERT [dbo].[Reviewer] ON 

GO
INSERT [dbo].[Reviewer] ([ReviewerKey], [ReviewerUserName], [ReviewerFirstName], [ReviewerLastName], [ReviewerEmail], [ReviewerKeyCode], [ReviewPlainPassword], [ReviewerHashedPass], [ReviewerDateEntered]) VALUES (1, N'gmartin', N'Greg', N'Martin', N'gmartin@gmail.com', 124923767, N'gmartinpass', 0xDF762DFA973ED99E22D99EF5ABB9CAE9E3C53A22D735588420575ED303F7C1DC648CBBDF776B16C89C06DE46CB32299EAF04E48E47B422DED18D6633FC911085, CAST(N'2015-10-17' AS Date))
GO
INSERT [dbo].[Reviewer] ([ReviewerKey], [ReviewerUserName], [ReviewerFirstName], [ReviewerLastName], [ReviewerEmail], [ReviewerKeyCode], [ReviewPlainPassword], [ReviewerHashedPass], [ReviewerDateEntered]) VALUES (2, N'maryg', N'Mary', N'Greene', N'maryg@msn.com', 161616630, N'marypassword', 0x65F05FE570585F3CC89357C60F41A0FC5DA51542C6BF4916532DA29589435BC9F6EC674A61A8AC5180DCE80E201D3F62CA4C3A95A90A45B9CD43B94DE31B751D, CAST(N'2015-11-07' AS Date))
GO
INSERT [dbo].[Reviewer] ([ReviewerKey], [ReviewerUserName], [ReviewerFirstName], [ReviewerLastName], [ReviewerEmail], [ReviewerKeyCode], [ReviewPlainPassword], [ReviewerHashedPass], [ReviewerDateEntered]) VALUES (3, N'wlewis', N'Wally', N'Lewis', N'wlewis@gmail.com', 101010407, N'wlewispass', 0xBB441E128279E11F2E321C9001209E240A50C885CC07BF7ACFD49A1F720372F84301C5AE5C7B54EE5A94D33E2E1A4AE56BDEA0F0A67386CDBE4E2F1303637185, CAST(N'2015-11-14' AS Date))
GO
INSERT [dbo].[Reviewer] ([ReviewerKey], [ReviewerUserName], [ReviewerFirstName], [ReviewerLastName], [ReviewerEmail], [ReviewerKeyCode], [ReviewPlainPassword], [ReviewerHashedPass], [ReviewerDateEntered]) VALUES (4, N'Janderson', N'Jason', N'Anderson', N'janderson@outlook.com', 131313693, N'jasonpass', 0x79407325542EC779C5C9FB35F3755FE169503923BCA25E367BE31B27FF274BEE3687A9AB90DF683366B0DE9FBC97E041B12CB4A07F05116314F283082989E168, CAST(N'2015-11-14' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Reviewer] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [unique_userName]    Script Date: 12/12/2015 10:06:23 AM ******/
ALTER TABLE [dbo].[Reviewer] ADD  CONSTRAINT [unique_userName] UNIQUE NONCLUSTERED 
(
	[ReviewerUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuthorBook]  WITH CHECK ADD  CONSTRAINT [FK_Author] FOREIGN KEY([Authorkey])
REFERENCES [dbo].[Author] ([AuthorKey])
GO
ALTER TABLE [dbo].[AuthorBook] CHECK CONSTRAINT [FK_Author]
GO
ALTER TABLE [dbo].[AuthorBook]  WITH CHECK ADD  CONSTRAINT [FK_Book] FOREIGN KEY([BookKey])
REFERENCES [dbo].[Book] ([BookKey])
GO
ALTER TABLE [dbo].[AuthorBook] CHECK CONSTRAINT [FK_Book]
GO
ALTER TABLE [dbo].[BookCategory]  WITH CHECK ADD  CONSTRAINT [FK_BookCat] FOREIGN KEY([BookKey])
REFERENCES [dbo].[Book] ([BookKey])
GO
ALTER TABLE [dbo].[BookCategory] CHECK CONSTRAINT [FK_BookCat]
GO
ALTER TABLE [dbo].[BookCategory]  WITH CHECK ADD  CONSTRAINT [FK_Category] FOREIGN KEY([CategoryKey])
REFERENCES [dbo].[Category] ([CategoryKey])
GO
ALTER TABLE [dbo].[BookCategory] CHECK CONSTRAINT [FK_Category]
GO
ALTER TABLE [dbo].[CheckinLog]  WITH CHECK ADD  CONSTRAINT [FK_ReviewerCheckIn] FOREIGN KEY([ReviewerKey])
REFERENCES [dbo].[Reviewer] ([ReviewerKey])
GO
ALTER TABLE [dbo].[CheckinLog] CHECK CONSTRAINT [FK_ReviewerCheckIn]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_BookRev] FOREIGN KEY([BookKey])
REFERENCES [dbo].[Book] ([BookKey])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_BookRev]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [Fk_Reviewer] FOREIGN KEY([ReviewerKey])
REFERENCES [dbo].[Reviewer] ([ReviewerKey])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [Fk_Reviewer]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [chk_Rating] CHECK  (([ReviewRating]>=(0) AND [ReviewRating]<=(5)))
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [chk_Rating]
GO
/****** Object:  StoredProcedure [dbo].[usp_NewReviewer]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[usp_NewReviewer] 
@ReviewerUserName NVarchar(255), 
@ReviewerFirstName Nvarchar(255), 
@ReviewerLastName NVarchar(255), 
@ReviewerEmail Nvarchar(255),  
@ReviewPlainPassword Nvarchar(50)
AS
Declare @KeyCode int
Declare @Date Date
Declare @userKey int
Declare @hashed VarBinary(500)
If not exists	
	(select ReviewerUserName, ReviewerEmail From Reviewer
	  where ReviewerUserName=@reviewerUserName 
	  And ReviewerEmail=@ReviewerEmail)
	Begin
	Set @KeyCode = dbo.fx_GetSeed()
	set @hashed=dbo.fx_HashPassword(@keycode,@ReviewPlainPassword)
	SET @dATE = gETDATE()

	Insert into Reviewer(ReviewerUserName, ReviewerFirstName, 
	ReviewerLastName, ReviewerEmail, ReviewerKeyCode, 
	ReviewPlainPassword, ReviewerHashedPass, ReviewerDateEntered)
	Values(@ReviewerUserName,@ReviewerFirstName,@ReviewerLastName,
	@ReviewerEmail,@KeyCode,@ReviewPlainPassword,@hashed,@Date)

	set @userKey=ident_current('Reviewer')

	return @userKey

	end
	Else
	Begin
	return -1
	End

GO
/****** Object:  StoredProcedure [dbo].[usp_ReviewerLogin]    Script Date: 12/12/2015 10:06:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_ReviewerLogin]
	@ReviewerUserName nvarchar(255),
	@ReviewerPassword nvarchar(255)
	As
	Declare @Keycode int
	Declare @UserKey int
	Declare @hashed varbinary(500)
	Declare @newHash varbinary(500)
	Set @userKey=0
	if exists
		(Select ReviewerKey,ReviewerKeyCode, ReviewerHashedPass
		from Reviewer
		Where ReviewerUserName=@reviewerUserName)
	begin
		Select @userKey=ReviewerKey,@KeyCode=ReviewerKeyCode, @hashed=ReviewerHashedPass
		from Reviewer
		Where ReviewerUserName=@reviewerUserName
		Set @newHash=dbo.fx_HashPassword(@Keycode, @ReviewerPassword)
		
		if(@hashed=@newHash)
		Begin
			print cast(@UserKey as nvarchar(20))
			Insert into CheckinLog(ReviewerKey, CheckinDateTime)
			values(@userKey,GetDate())

			
		end
		else
		begin
			print 'invalid login'
			return -1
		end


	end
	else
	begin
		print 'invalid login'
		return -1
	end
	return @UserKey
GO
USE [master]
GO
ALTER DATABASE [BookReviewDb] SET  READ_WRITE 
GO
