USE [master]
GO
/****** Object:  Database [ShowTracker]    Script Date: 12/12/2015 9:45:52 AM ******/
IF EXISTS
   (SELECT name FROM sys.Databases where Name='ShowTracker')
BEGIN
DROP DATABASE ShowTracker
END
GO
CREATE DATABASE [ShowTracker]

GO
USE [ShowTracker]
GO
/****** Object:  UserDefinedFunction [dbo].[fx_GetSeed]    Script Date: 12/12/2015 9:45:52 AM ******/
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
/****** Object:  UserDefinedFunction [dbo].[fx_HashPassword]    Script Date: 12/12/2015 9:45:52 AM ******/
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
/****** Object:  Table [dbo].[Artist]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Artist](
	[ArtistKey] [int] IDENTITY(1,1) NOT NULL,
	[ArtistName] [nvarchar](255) NOT NULL,
	[ArtistEmail] [nvarchar](255) NOT NULL,
	[ArtistWebPage] [nvarchar](255) NULL,
	[ArtistDateEntered] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[ArtistKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Fan]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fan](
	[FanKey] [int] IDENTITY(1,1) NOT NULL,
	[FanName] [nvarchar](255) NULL,
	[FanEmail] [nvarchar](255) NOT NULL,
	[FanDateEntered] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[FanKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FanArtist]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FanArtist](
	[FanKey] [int] NOT NULL,
	[ArtistKey] [int] NOT NULL,
 CONSTRAINT [FanArtistKey] PRIMARY KEY CLUSTERED 
(
	[FanKey] ASC,
	[ArtistKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FanLogin]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FanLogin](
	[FanLoginKey] [int] IDENTITY(1,1) NOT NULL,
	[FanKey] [int] NULL,
	[FanLoginUserName] [nvarchar](255) NOT NULL,
	[FanLoginPasswordPlain] [nvarchar](255) NOT NULL,
	[FanLoginRandom] [int] NOT NULL,
	[FanLoginHashed] [varbinary](500) NULL,
	[FanLoginDateAdded] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[FanLoginKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LoginHistory]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoginHistory](
	[LoginHistorykey] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NOT NULL,
	[LoginHistoryDateTime] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[LoginHistorykey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Show]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Show](
	[ShowKey] [int] IDENTITY(1,1) NOT NULL,
	[ShowName] [nvarchar](255) NULL,
	[VenueKey] [int] NULL,
	[ShowDate] [date] NOT NULL,
	[ShowTime] [time](7) NOT NULL,
	[ShowTicketInfo] [nvarchar](255) NOT NULL,
	[ShowDateEntered] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[ShowKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShowDetail]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShowDetail](
	[ShowDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[ShowKey] [int] NULL,
	[ArtistKey] [int] NULL,
	[ShowDetailArtistStartTime] [time](7) NOT NULL,
	[ShowDetailAdditional] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ShowDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Venue]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Venue](
	[VenueKey] [int] IDENTITY(1,1) NOT NULL,
	[VenueName] [nvarchar](255) NOT NULL,
	[VenueAddress] [nvarchar](255) NOT NULL,
	[VenueCity] [nvarchar](255) NOT NULL,
	[VenueState] [nchar](2) NOT NULL,
	[VenueZipCode] [nchar](10) NOT NULL,
	[VenuePhone] [nchar](13) NOT NULL,
	[VenueEmail] [nvarchar](255) NULL,
	[VenueWebPage] [nvarchar](255) NULL,
	[VenueAgeRestriction] [int] NULL,
	[VenueDateAdded] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[VenueKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VenueLogin]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VenueLogin](
	[VenueLoginKey] [int] IDENTITY(1,1) NOT NULL,
	[VenueKey] [int] NULL,
	[VenueLoginUserName] [nvarchar](255) NOT NULL,
	[VenueLoginPasswordPlain] [nvarchar](255) NOT NULL,
	[VenueLoginRandom] [int] NOT NULL,
	[VenueLoginHashed] [varbinary](500) NULL,
	[VenueLoginDateAdded] [datetime] NULL DEFAULT (getdate()),
PRIMARY KEY CLUSTERED 
(
	[VenueLoginKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Artist] ON 

GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (1, N'NoBunny', N'nobunny@msn.com', N'www.nobunny.com', CAST(N'2015-11-11 13:50:24.753' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (2, N'Black Breath', N'bbreath@gmail.com', NULL, CAST(N'2015-11-11 13:50:24.753' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (3, N'Boss Martians', N'martians@gmail.com', NULL, CAST(N'2015-11-11 13:50:24.753' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (4, N'Erik Blood', N'erikblood@outlook.com', NULL, CAST(N'2015-11-11 13:50:24.753' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (5, N'Taj Mahal', N'theTaj@msn.com', NULL, CAST(N'2015-11-11 14:02:41.650' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (6, N'Leo Kottke', N'leo@gmail.com', NULL, CAST(N'2015-11-11 14:02:41.650' AS DateTime))
GO
INSERT [dbo].[Artist] ([ArtistKey], [ArtistName], [ArtistEmail], [ArtistWebPage], [ArtistDateEntered]) VALUES (7, N'The Average White Band', N'awb@yahoo.com', NULL, CAST(N'2015-11-11 14:02:41.650' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Artist] OFF
GO
SET IDENTITY_INSERT [dbo].[Fan] ON 

GO
INSERT [dbo].[Fan] ([FanKey], [FanName], [FanEmail], [FanDateEntered]) VALUES (1, N'Marty McFly', N'BTTF@gmail.com', CAST(N'2015-10-24 13:13:26.693' AS DateTime))
GO
INSERT [dbo].[Fan] ([FanKey], [FanName], [FanEmail], [FanDateEntered]) VALUES (2, N'Mary Taylor', N'mtaylor@outlook.com', CAST(N'2015-11-11 14:17:44.247' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Fan] OFF
GO
INSERT [dbo].[FanArtist] ([FanKey], [ArtistKey]) VALUES (1, 2)
GO
INSERT [dbo].[FanArtist] ([FanKey], [ArtistKey]) VALUES (1, 3)
GO
INSERT [dbo].[FanArtist] ([FanKey], [ArtistKey]) VALUES (1, 5)
GO
INSERT [dbo].[FanArtist] ([FanKey], [ArtistKey]) VALUES (2, 5)
GO
INSERT [dbo].[FanArtist] ([FanKey], [ArtistKey]) VALUES (2, 6)
GO
SET IDENTITY_INSERT [dbo].[FanLogin] ON 

GO
INSERT [dbo].[FanLogin] ([FanLoginKey], [FanKey], [FanLoginUserName], [FanLoginPasswordPlain], [FanLoginRandom], [FanLoginHashed], [FanLoginDateAdded]) VALUES (1, 1, N'mcFly', N'mcflyPass', 131313693, 0xD74AC3142CD136F23C93376814A6E641F24162580EA870D995C73D8091E7BFDF68054FB33D5BA28095C6D580FA7759EBE9821ADFF1A4E5268DEBF3C7541FFBE1, CAST(N'2015-10-24 13:13:26.693' AS DateTime))
GO
INSERT [dbo].[FanLogin] ([FanLoginKey], [FanKey], [FanLoginUserName], [FanLoginPasswordPlain], [FanLoginRandom], [FanLoginHashed], [FanLoginDateAdded]) VALUES (2, 2, N'mtaylor', N'mtaylorPass', 141414247, 0xC13A06F5CDEB81A02E86B5A18CA13286A36139967EBAF389A7682110A4A05EE3EB7924E79879A0206AAD9D61EF766F666E84550EBBD011FA3142749C70C7F9C1, CAST(N'2015-11-11 14:17:44.247' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[FanLogin] OFF
GO
SET IDENTITY_INSERT [dbo].[LoginHistory] ON 

GO
INSERT [dbo].[LoginHistory] ([LoginHistorykey], [UserName], [LoginHistoryDateTime]) VALUES (1, N'thealley', CAST(N'2015-10-24 12:55:15.103' AS DateTime))
GO
INSERT [dbo].[LoginHistory] ([LoginHistorykey], [UserName], [LoginHistoryDateTime]) VALUES (2, N'mcfly', CAST(N'2015-10-24 13:18:08.410' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[LoginHistory] OFF
GO
SET IDENTITY_INSERT [dbo].[Show] ON 

GO
INSERT [dbo].[Show] ([ShowKey], [ShowName], [VenueKey], [ShowDate], [ShowTime], [ShowTicketInfo], [ShowDateEntered]) VALUES (1, N'Nightly', 1, CAST(N'2015-12-05' AS Date), CAST(N'21:00:00' AS Time), N'$15 at door', CAST(N'2015-11-11 13:53:12.363' AS DateTime))
GO
INSERT [dbo].[Show] ([ShowKey], [ShowName], [VenueKey], [ShowDate], [ShowTime], [ShowTicketInfo], [ShowDateEntered]) VALUES (2, N'Nightly', 1, CAST(N'2015-12-10' AS Date), CAST(N'20:00:00' AS Time), N'$17 at door', CAST(N'2015-11-11 13:58:06.423' AS DateTime))
GO
INSERT [dbo].[Show] ([ShowKey], [ShowName], [VenueKey], [ShowDate], [ShowTime], [ShowTicketInfo], [ShowDateEntered]) VALUES (3, N'Taj Mahal', 2, CAST(N'2015-11-15' AS Date), CAST(N'21:00:00' AS Time), N'$35 available at ticketmaster', CAST(N'2015-11-11 14:04:23.680' AS DateTime))
GO
INSERT [dbo].[Show] ([ShowKey], [ShowName], [VenueKey], [ShowDate], [ShowTime], [ShowTicketInfo], [ShowDateEntered]) VALUES (4, N'Leo Kottkey', 2, CAST(N'2015-11-15' AS Date), CAST(N'21:00:00' AS Time), N'$35 available at ticketmaster', CAST(N'2015-11-11 14:05:42.983' AS DateTime))
GO
INSERT [dbo].[Show] ([ShowKey], [ShowName], [VenueKey], [ShowDate], [ShowTime], [ShowTicketInfo], [ShowDateEntered]) VALUES (5, N'The Average White Band', 2, CAST(N'2015-12-19' AS Date), CAST(N'21:00:00' AS Time), N'$40 available at ticketmaster', CAST(N'2015-11-11 14:09:02.457' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Show] OFF
GO
SET IDENTITY_INSERT [dbo].[ShowDetail] ON 

GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (1, 1, 1, CAST(N'21:00:00' AS Time), N'first act')
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (2, 1, 2, CAST(N'22:30:00' AS Time), N'Second Act')
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (3, 2, 3, CAST(N'20:00:00' AS Time), N'first act')
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (4, 2, 4, CAST(N'22:00:00' AS Time), N'Second Act')
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (5, 3, 5, CAST(N'21:00:00' AS Time), NULL)
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (6, 4, 6, CAST(N'21:00:00' AS Time), NULL)
GO
INSERT [dbo].[ShowDetail] ([ShowDetailKey], [ShowKey], [ArtistKey], [ShowDetailArtistStartTime], [ShowDetailAdditional]) VALUES (7, 5, 7, CAST(N'21:00:00' AS Time), NULL)
GO
SET IDENTITY_INSERT [dbo].[ShowDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Venue] ON 

GO
INSERT [dbo].[Venue] ([VenueKey], [VenueName], [VenueAddress], [VenueCity], [VenueState], [VenueZipCode], [VenuePhone], [VenueEmail], [VenueWebPage], [VenueAgeRestriction], [VenueDateAdded]) VALUES (1, N'Comet', N'102 Pine', N'Seattle', N'Wa', N'98122     ', N'2065551000   ', N'comet@gmail.com', N'http://www.comet.com', 21, CAST(N'2015-10-24 12:03:33.420' AS DateTime))
GO
INSERT [dbo].[Venue] ([VenueKey], [VenueName], [VenueAddress], [VenueCity], [VenueState], [VenueZipCode], [VenuePhone], [VenueEmail], [VenueWebPage], [VenueAgeRestriction], [VenueDateAdded]) VALUES (2, N'Jazz Alley', N'3004 5th Avenue', N'Seattle', N'WA', N'98124     ', N'2065551001   ', N'jalley@gmail.com', N'http://www.jazzAlley.com', 21, CAST(N'2015-10-24 12:08:58.980' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Venue] OFF
GO
SET IDENTITY_INSERT [dbo].[VenueLogin] ON 

GO
INSERT [dbo].[VenueLogin] ([VenueLoginKey], [VenueKey], [VenueLoginUserName], [VenueLoginPasswordPlain], [VenueLoginRandom], [VenueLoginHashed], [VenueLoginDateAdded]) VALUES (1, 1, N'thecomet', N'cometPass', 121212420, 0xF4C50F4B43851DE705DB8ACCF34610E11DF824C0A02117DFAAABB5D132FFBF2FAF9F15AB1D2626AF43C4D1CF630E1A37B791055AF4F7EAA3E015E7664FE9CDA0, CAST(N'2015-10-24 12:03:33.420' AS DateTime))
GO
INSERT [dbo].[VenueLogin] ([VenueLoginKey], [VenueKey], [VenueLoginUserName], [VenueLoginPasswordPlain], [VenueLoginRandom], [VenueLoginHashed], [VenueLoginDateAdded]) VALUES (2, 2, N'thealley', N'cjazzPass', 121212980, 0xF3278ECD481DAC71C8B9DE11C29770F07CF9D8C5C53642111655C3FB420D829682C6E243F5E834A7A4C4CE5505869E190F5D44BBD06ACE38FDC3FC4610E3B68A, CAST(N'2015-10-24 12:08:58.980' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[VenueLogin] OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__FanLogin__153D05DDE38633E3]    Script Date: 12/12/2015 9:45:52 AM ******/
ALTER TABLE [dbo].[FanLogin] ADD UNIQUE NONCLUSTERED 
(
	[FanLoginUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__FanLogin__4AA09DD9A5C0FD7E]    Script Date: 12/12/2015 9:45:52 AM ******/
ALTER TABLE [dbo].[FanLogin] ADD UNIQUE NONCLUSTERED 
(
	[FanLoginPasswordPlain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__VenueLog__54C4772B12F5185A]    Script Date: 12/12/2015 9:45:52 AM ******/
ALTER TABLE [dbo].[VenueLogin] ADD UNIQUE NONCLUSTERED 
(
	[VenueLoginUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__VenueLog__92766FA67CB96DCA]    Script Date: 12/12/2015 9:45:52 AM ******/
ALTER TABLE [dbo].[VenueLogin] ADD UNIQUE NONCLUSTERED 
(
	[VenueLoginPasswordPlain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FanArtist]  WITH CHECK ADD FOREIGN KEY([ArtistKey])
REFERENCES [dbo].[Artist] ([ArtistKey])
GO
ALTER TABLE [dbo].[FanArtist]  WITH CHECK ADD FOREIGN KEY([FanKey])
REFERENCES [dbo].[Fan] ([FanKey])
GO
ALTER TABLE [dbo].[FanLogin]  WITH CHECK ADD FOREIGN KEY([FanKey])
REFERENCES [dbo].[Fan] ([FanKey])
GO
ALTER TABLE [dbo].[Show]  WITH CHECK ADD FOREIGN KEY([VenueKey])
REFERENCES [dbo].[Venue] ([VenueKey])
GO
ALTER TABLE [dbo].[ShowDetail]  WITH CHECK ADD FOREIGN KEY([ArtistKey])
REFERENCES [dbo].[Artist] ([ArtistKey])
GO
ALTER TABLE [dbo].[ShowDetail]  WITH CHECK ADD FOREIGN KEY([ShowKey])
REFERENCES [dbo].[Show] ([ShowKey])
GO
ALTER TABLE [dbo].[VenueLogin]  WITH CHECK ADD FOREIGN KEY([VenueKey])
REFERENCES [dbo].[Venue] ([VenueKey])
GO
/****** Object:  StoredProcedure [dbo].[usp_FanLogin]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[usp_FanLogin]
		@username nvarchar(255),
		@password nvarchar(255)
		As
		Declare @userKey int
		Declare @seed int
		Declare @hash varbinary(500)
		Declare @newHash varbinary(500)
		
		Set @UserKey=0
		Select @seed = FanLoginRandom, @hash=FanLoginHashed
			from FanLogin 
			where FanLoginUserName=@userName
		if not @seed is null
		Begin
			set @newHash = dbo.fx_HashPassword(@seed, @password)
			if @hash=@newHash
			Begin 
				Select @userKey=FanKey from Fanlogin
				Where FanLoginuserName=@UserName 
				and FanLoginHashed=@newHash

				insert into LoginHistory(UserName, LoginHistoryDateTime)
				Values(@userName, GetDate())
			end

		end
		print cast(@userKey as nvarchar(3))
		Return @userKey
GO
/****** Object:  StoredProcedure [dbo].[usp_RegisterFan]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[usp_RegisterFan]
@FanName nvarchar(255), 
@FanEmail nvarchar(255),
@FanUsername nvarchar(255),
@fanPassword nvarchar(255)
As
Declare @Seed int
Declare @DateEntered DateTime
Declare @hash varbinary(500)
	if not exists 
		(Select fankey from fan
		where fanName=@fanName
		aND fanemail=@fanEmail)
	Begin
		Begin tran
			Begin try
				Set @dateEntered = GetDate()
				set @seed = dbo.fx_GetSeed();
				set @hash=dbo.fx_HashPassword(@Seed, @fanPassword)

				Insert into Fan(FanName, FanEmail, FanDateEntered)
				Values(@fanName, @fanEmail, @DateEntered)

				Insert into FanLogin(FanKey, 
				FanLoginUserName, 
				FanLoginPasswordPlain, 
				FanLoginRandom, 
				FanLoginHashed, 
				FanLoginDateAdded)
				Values(
				Ident_current('Fan'),
				@fanUserName,
				@fanPassword,
				@seed,
				@hash,
				@dateEntered)

			commit tran
		end try
		begin catch
			rollback tran
			return error_number()
		End catch
	End
	Else
		Begin
			return -1
		end
GO
/****** Object:  StoredProcedure [dbo].[usp_RegisterVenue]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RegisterVenue]
@VenueName nvarchar(255), 
@VenueAddress nvarchar(255), 
@VenueCity nvarchar (255) = 'Seattle', 
@VenueState nchar(2) ='WA', 
@VenueZipCode nchar(10), 
@VenuePhone nchar(13), 
@VenueEmail nvarchar(255)=null, 
@VenueWebPage nvarchar(255)=null, 
@VenueAgeRestriction int=null,
@VenueLoginUserName nvarchar(255), 
@VenueLoginPasswordPlain nvarchar(255)
As
if not exists
	(Select venueKey from Venue
	  Where VenueName=@VenueName
	  And VenueAddress=@VenueAddress
	  And VenueCity=@VenueCity)
Begin 
	Begin try
		Begin Tran
		Declare @VenueDateAdded DateTime
		Declare @seed int
		Declare @hashed varbinary(500)
		Set @Seed = dbo.fx_GetSeed()
		set @hashed=dbo.fx_HashPassword(@seed,@VenueLoginPasswordPlain)
		Set @VenueDateAdded=GetDate()
		
		Insert into Venue
		(VenueName, 
		VenueAddress, 
		VenueCity, 
		VenueState, 
		VenueZipCode, 
		VenuePhone, 
		VenueEmail, 
		VenueWebPage, 
		VenueAgeRestriction, 
		VenueDateAdded)
		Values
		(@VenueName, 
		@VenueAddress, 
		@VenueCity, 
		@VenueState, 
		@VenueZipCode, 
		@VenuePhone, 
		@VenueEmail, 
		@VenueWebPage, 
		@VenueAgeRestriction, 
		@VenueDateAdded)

		Insert into VenueLogin(
		VenueKey, 
		VenueLoginUserName, 
		VenueLoginPasswordPlain, 
		VenueLoginRandom, 
		VenueLoginHashed, 
		VenueLoginDateAdded)
		Values(
		Ident_current('Venue'),
		@VenueLoginUserName,
		@VenueLoginPasswordPlain,
		@Seed,
		@hashed,
		@VenueDateAdded
		)

		commit tran
		End try
		Begin Catch
		rollback tran
		return error_number()
		end catch
	end
	else
		begin
			return -1
		end
GO
/****** Object:  StoredProcedure [dbo].[usp_venueLogin]    Script Date: 12/12/2015 9:45:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_venueLogin]
		@username nvarchar(255),
		@password nvarchar(255)
		As
		Declare @userKey int
		Declare @seed int
		Declare @hash varbinary(500)
		Declare @newHash varbinary(500)
		
		Set @UserKey=0
		Select @seed = VenueLoginRandom, @hash=VenueLoginHashed
			from VenueLogin 
			where VenueLoginUserName=@userName
		if not @seed is null
		Begin
			set @newHash = dbo.fx_HashPassword(@seed, @password)
			if @hash=@newHash
			Begin 
				Select @userKey=VenueKey from Venuelogin
				Where VenueLoginuserName=@UserName 
				and VenueLoginHashed=@newHash

				insert into LoginHistory(UserName, LoginHistoryDateTime)
				Values(@userName, GetDate())
			end

		end
		print cast(@userKey as nvarchar(3))
		Return @userKey



GO
USE [master]
GO
ALTER DATABASE [ShowTracker] SET  READ_WRITE 
GO
