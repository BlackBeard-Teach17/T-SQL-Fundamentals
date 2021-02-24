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
	TMStamp TIMESTAMP,
    CONSTRAINT PK_Bid PRIMARY KEY CLUSTERED (BidID)
);


CREATE TABLE Product
(
    ProductID INT IDENTITY(1,1),
    CategoryID INT FOREIGN KEY REFERENCES Category(CategoryID),
    MarkID INT FOREIGN KEY REFERENCES LivestockMark(MarkID),
	AuctionID INT FOREIGN KEY REFERENCES AuctionEvent(AuctionEventID),
	Breed VARCHAR(100),
    ProductWeight INT DEFAULT 50,
    Gender VARCHAR(7) DEFAULT 'Unknown',
    Lot INT,
    StartingBid INT NOT NULL DEFAULT 1000,
	ProductStatus VARCHAR(20) NOT NULL DEFAULT 'Available',
    BidID INT FOREIGN KEY REFERENCES Bid(BidID),
    SellerID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductImage VARBINARY(MAX),
	TMStamp TIMESTAMP
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
    Method VARCHAR(100),
	TMStamp TIMESTAMP
);

CREATE TABLE Trans
(
    TransID INT IDENTITY (1,1),
    BuyerID INT,
    ProductID INT,
	Price INT NOT NULL,
    VAT INT,
	TMStamp TIMESTAMP

	CONSTRAINT PK_TransID PRIMARY KEY (TransID)
);


CREATE TABLE BankingDetails 
(
	BankingDetailsID INT IDENTITY(1,1),
	UserID INT FOREIGN KEY REFERENCES Users(UserID),
	AccountName VARCHAR(200),
	BankName VARCHAR(200) NOT NULL,
	AccountNo INT NOT NULL UNIQUE,
	SwiftID VARCHAR(12),
	AccountType VARCHAR(20) NOT NULL,
	BranchCode INT NOT NULL,
	Balance INT DEFAULT '0',
	TMStamp TIMESTAMP

	CONSTRAINT PK_BankingDetails PRIMARY KEY(BankingDetailsID)
);

CREATE TABLE ClientAddress
(
	AddressID INT IDENTITY(1,1),
	UserID INT FOREIGN KEY REFERENCES Users(UserID),
	AddressType VARCHAR(4),
	Line1 VARCHAR(50) NOT NULL,
	Line2 VARCHAR(50) NULL,
	Line3 VARCHAR(50),
	City VARCHAR(50) NOT NULL,
	PostCode VARCHAR(10),
	Province VARCHAR(50),
	TMStamp DATETIME

	CONSTRAINT PK_AddressID PRIMARY KEY(AddressID)
);

ALTER TABLE Users
	ADD AddressID INT FOREIGN KEY REFERENCES ClientAddress(AddressID)
ALTER TABLE Users
	ADD BankingDetailsID INT FOREIGN KEY REFERENCES BankingDetails(BankingDetailsID)

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
GO;
--Select Statements

--Views
CREATE VIEW DetailsView AS
SELECT p.Breed, p.AuctionID, p.ProductImage,p.productWeight, c.CategoryName, b.CurrentBid
FROM Product p 
INNER JOIN Category c ON p.CategoryID = c.CategoryID
INNER JOIN Bid b ON p.BidID = b.BidID;
GO;

--View banking details
CREATE VIEW BankingDetailsView AS 
SELECT b.BankName, b.AccountName, b.AccountNo, b.Balance, u.LastName 
FROM BankingDetails b
LEFT JOIN Users u
ON b.UserID = u.UserID;
GO;
--Insert into view to test

CREATE VIEW AddressView AS
SELECT a.Line1, a.Line2, a.Line3, a.City, a.PostCode, u.LastName
FROM ClientAddress a
INNER JOIN Users u
ON a.AddressID = u.AddressID;
GO;



GO;
--Stored Procedure
USE Auction;
GO

CREATE PROCEDURE uspInsertUserDetails
    @FirstName VARCHAR(200),
    @LastName VARCHAR(200),
    @Email VARCHAR(100),
    @Password VARCHAR(1000),
    @IdentityNo INT
AS
SET NOCOUNT ON
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                INSERT INTO
                    Users(FirstName,LastName,PASSWORD,Email,IdentityNo)
                VALUES
                    (@FirstName, @LastName,@Password,@Email,@IdentityNo)
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

EXECUTE uspInsertUserDetails 'Zeke', 'Jaegar', '98a0276b3e0ea0ac9fffd81bd8fc602b', 'zeke@aot.com', 0101015142084
GO;

CREATE PROCEDURE uspUpdateUserAddressDetails 
		@UserID AS INT,
		@AddressLine1 AS VARCHAR(200),
		@AddressLine2 AS VARCHAR(200),
		@CITY AS VARCHAR(200),
		@PostCode AS VARCHAR(10)
AS
SET NOCOUNT ON
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                UPDATE ClientAddress
                    SET Line1 = @AddressLine1,
                        Line2 = @AddressLine2,
                        CITY = @CITY,
                        PostCode = @PostCode
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
CREATE TRIGGER update_product_status
ON Bid
FOR UPDATE 
AS 
DECLARE @ProductID INT,
		@BidID INT,
		@AuctionID INT

IF UPDATE(WinBid)
BEGIN 
	UPDATE Product SET ProductStatus = 'Sold' where ProductID = @ProductID;
END
GO;



 
