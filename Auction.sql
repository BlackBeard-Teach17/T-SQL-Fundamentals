CREATE DATABASE Auction;

--DROP DATABASE Auction;

BACKUP DATABASE Auction
    TO DISK = 'C:\backups\auctionDB.bak'
WITH DIFFERENTIAL;

USE Auction;
GO

CREATE TABLE Officiators
(
    OfficiatorID INT IDENTITY (1,1),
    TradingName VARCHAR(100),
    TaxNo INT NOT NULL UNIQUE,
    VatNo INT NOT NULL UNIQUE,
    TMStamp TIMESTAMP
    CONSTRAINT PK_Official PRIMARY KEY CLUSTERED (OfficiatorID)
);

CREATE TABLE UserStatus
(
    StatusID INT IDENTITY (1,1),
    StatusType VARCHAR(50),
    TMStamp TIMESTAMP,
    CONSTRAINT PK_Status PRIMARY KEY (StatusID)
);


CREATE TABLE Users
(
    UserID INT IDENTITY (1,1),
    FirstName VARCHAR(200) NOT NULL,
    LastName VARCHAR(200) NOT NULL,
    AddressLine1 VARCHAR(200) NOT NULL,
    AddressLine2 VARCHAR(200),
    CITY VARCHAR(200) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PASSWORD VARCHAR(1000) NOT NULL,
    IdentityNo INT NOT NULL UNIQUE,
    Status VARCHAR(20) DEFAULT 'Unverified',
    TMStamp TIMESTAMP

    CONSTRAINT PK_USER_ID PRIMARY KEY CLUSTERED
    (
        UserID
    )
);

CREATE TABLE Blacklist
(
    BlacklistID INT IDENTITY (1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    FromBuying CHAR(1) NOT NULL DEFAULT 'N',
    FromSelling CHAR(1) NOT NULL DEFAULT 'N',
    Reason TEXT NOT NULL,
    TMStamp TIMESTAMP, 
	CONSTRAINT PK_BlacklistID PRIMARY KEY CLUSTERED(BlacklistID)
);

CREATE TABLE LivestockMark
(
    MarkID INT IDENTITY(1,1),
    MarkSymbol VARCHAR(3) NOT NULL UNIQUE,
    IssueDate DATE NOT NULL,
    TMStamp TIMESTAMP
    CONSTRAINT PK_Livestock_Mark PRIMARY KEY CLUSTERED (MarkID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID)
);

CREATE TABLE Category
(
    CategoryID INT IDENTITY(1,1),
    CategoryName VARCHAR(200) NOT NULL UNIQUE,
    TMStamp TIMESTAMP
	CONSTRAINT PK_Category PRIMARY KEY CLUSTERED(CategoryID)
);

CREATE TABLE Breed
(
    BreedID INT IDENTITY(1,1) UNIQUE,
    Breed VARCHAR(200) NOT NULL UNIQUE,
    Category VARCHAR(200) REFERENCES Category(CategoryName),
    TMStamp TIMESTAMP,
    CONSTRAINT PK_Breed PRIMARY KEY (Breed)
);

CREATE TABLE AuctionEvent
(
    AuctionEventID INT IDENTITY (1,1),
    OfficiatorID INT FOREIGN KEY REFERENCES Officiators(OfficiatorID),
    AuctionAddress VARCHAR(400) NOT NULL,
	AuctionName VARCHAR(200) NOT NULL,
    AuctionDate DATE,
    NoOfSeats INT NOT NULL DEFAULT 50,
    AuctionType VARCHAR(30) NOT NULL DEFAULT 'Hybrid',
    ClosingTime DATETIME,
    TMStamp TIMESTAMP,
    CONSTRAINT PK_event PRIMARY KEY (AuctionEventID)
);

CREATE TABLE Bid
(
    BidID INT IDENTITY (1,1),
    AuctionID INT FOREIGN KEY REFERENCES AuctionEvent(AuctionEventID),
    CurrentBid INT NOT NULL DEFAULT 0,
    WinBid INT NOT NULL DEFAULT '0',
    BuyerID INT FOREIGN KEY REFERENCES Users(UserID),
    CONSTRAINT PK_Bid PRIMARY KEY CLUSTERED (BidID)
);


CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    MarkID INT FOREIGN KEY REFERENCES LivestockMark(MarkID),
    Weight INT DEFAULT 50,
    Gender VARCHAR(7) DEFAULT 'Unknown',
    Lot INT,
    StartingBid INT NOT NULL DEFAULT 1000,
	ProductStatus VARCHAR(20) NOT NULL DEFAULT 'Available',
    BidID INT FOREIGN KEY REFERENCES Bid(BidID),
    SellerID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductImage VARBINARY(MAX)
);

ALTER TABLE Product
	ADD CONSTRAINT PK_ProductID
	PRIMARY KEY(ProductID);

ALTER TABLE Bid
	ADD ProductID INT;

ALTER TABLE Bid
	ADD CONSTRAINT FK_ProductID
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID);

CREATE TABLE Participant
(
    ParticipantID INT IDENTITY (1,1) UNIQUE,
    AuctionID INT FOREIGN KEY REFERENCES AuctionEvent(AuctionEventID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Method VARCHAR(100)
);

CREATE TABLE Trans
(
    TransID INT IDENTITY (1,1),
    BuyerID INT, --FOREIGN KEY REFERENCES Bid(BuyerID),Can't do this 
    --SellerID INT FOREIGN KEY REFERENCES
    ProductID INT, --FOREIGN KEY REFERENCES Bid(ProductID),
    VAT INT,
);

--INSERT STATEMENTS
IF NOT EXISTS(SELECT StatusType FROM UserStatus WHERE StatusType = 'Unverified')
	INSERT INTO UserStatus(StatusType) VALUES ('Unverified');

IF NOT EXISTS(SELECT StatusType FROM UserStatus WHERE StatusType = 'Verified')
INSERT INTO UserStatus(StatusType) VALUES ('Verified');

IF NOT EXISTS(SELECT StatusType FROM UserStatus WHERE StatusType = 'Blacklisted')
INSERT INTO UserStatus(StatusType) VALUES ('Blacklisted');

--Category Inserts
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Cow')
	INSERT INTO Category(CategoryName) VALUES('Cow');
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Pig')
	INSERT INTO Category(CategoryName) VALUES('Pig');
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Horse')
	INSERT INTO Category(CategoryName) VALUES('Horse');
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Goat')
	INSERT INTO Category(CategoryName) VALUES('Goat');
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Sheep')
	INSERT INTO Category(CategoryName) VALUES('Sheep');
IF NOT EXISTS(SELECT CategoryName FROM Category WHERE CategoryName = 'Donkey')
	INSERT INTO Category(CategoryName) VALUES('Donkey');

--Stored Procedure
USE Auction;
GO

CREATE PROCEDURE uspInsertUserDetails
    @FirstName VARCHAR(200),
    @LastName VARCHAR(200),
    @AddressLine1 VARCHAR(200),
    @AddressLine2 VARCHAR(200),
    @CITY VARCHAR(200),
    @PostalCode VARCHAR(10),
    @Email VARCHAR(100),
    @Password VARCHAR(1000),
    @IdentityNo INT
AS
SET NOCOUNT ON
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                INSERT INTO
                    Users(FirstName,LastName,AddressLine1,AddressLine2,CITY,PostalCode,PASSWORD,Email,IdentityNo)
                VALUES
                    (@FirstName, @LastName,@AddressLine1, @AddressLine2, @CITY,@PostalCode,@Password,@Email,@IdentityNo)
                PRINT 'Insert complete...'
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
            PRINT ERROR_MESSAGE();
            PRINT ERROR_LINE();
            ROLLBACK TRANSACTION;
        END CATCH
    END
GO;

EXECUTE uspInsertUserDetails 'Zeke', 'Jaegar', '17 Beast Titan Street', 'Riberio', 'Marley', '20010', 'zeke@aot.com', '98a0276b3e0ea0ac9fffd81bd8fc602b', 0101015142084
GO;

CREATE PROCEDURE uspUpdateUserAddressDetails 
		@UserID AS INT,
		@AddressLine1 AS VARCHAR(200),
		@AddressLine2 AS VARCHAR(200),
		@CITY AS VARCHAR(200),
		@PostalCode AS VARCHAR(10)
AS
SET NOCOUNT ON
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                UPDATE Users
                    SET AddressLine1 = @AddressLine1,
                        AddressLine2 = @AddressLine2,
                        CITY = @CITY,
                        PostalCode = @PostalCode
                WHERE UserID = @UserID
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
            PRINT ERROR_MESSAGE();
            PRINT ERROR_LINE();
            ROLLBACK TRANSACTION;
        END CATCH
    END

GO;

CREATE PROCEDURE uspUserBids
	@AuctionID INT,
    @CurrentBid INT,
    @BuyerID INT,
	@ProductID INT
AS
SET NOCOUNT ON;
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
				IF @CurrentBid > ufn_LargestBid(@AuctionID, @ProductID)
					INSERT INTO Bid (AuctionID, CurrentBid, BuyerID, ProductID)
						VALUES(@AuctionID, @CurrentBid, @BuyerID, @ProductID)
				ELSE
					PRINT 'Place a higher bid'
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
			IF @@ERROR > 0
				ROLLBACK TRANSACTION
			PRINT ERROR_MESSAGE();
        END CATCH
    END
GO;

EXECUTE uspUserBids 1, 2000, 1, 2;
GO


--UDF to get the current largest bid
CREATE FUNCTION dbo.ufn_LargestBid(@AuctionID INT, @ProductID INT)
RETURNS INT
AS
BEGIN
	DECLARE @MaxBid INT;
	SELECT @MaxBid = MAX(b.CurrentBid)
	FROM Bid b
	WHERE b.AuctionID = @AuctionID
		AND b.ProductID = @ProductID;

	IF(@MaxBid IS NULL)
		SET @MaxBid = 0;
	RETURN @MaxBid;
END
GO;
--A trigger to update the Products table to set ProductStatus to sold after successful bidding
CREATE TRIGGER registration_reminder
ON Users
AFTER INSERT
AS
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'Auction Admin',
	@recipients = 
	
	DECLARE @LastName AS VARCHAR(200) = (SELECT LastName FROM Users WHERE UserID = MAX(UserID));

	@profile_name = 