CREATE DATABASE Auction;

BACKUP DATABASE Auction
    TO DISK = 'C:\backups\auctionDB.bak'
WITH DIFFERENTIAL;

USE Auction;
GO

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
    Status VARCHAR(20) REFERENCES UserStatus(StatusType) DEFAULT 'Unverified',
    TMStamp TIMESTAMP

    CONSTRAINT PK_USER_ID PRIMARY KEY CLUSTERED
    (
        UserID
    )
);

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
)

CREATE TABLE Blacklist
(
    BlacklistID INT IDENTITY (1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    FromBuying CHAR(1) NOT NULL DEFAULT 'N',
    FromSelling CHAR(1) NOT NULL DEFAULT 'Y',
    Reason TEXT NOT NULL,
    TMStamp TIMESTAMP
)

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
);

CREATE TABLE Breed
(
    BreedID INT IDENTITY(1,1) UNIQUE,
    Breed VARCHAR(200) NOT NULL UNIQUE,
    Category VARCHAR(200),
    TMStamp TIMESTAMP,
    CONSTRAINT PK_Breed PRIMARY KEY (Breed)
);

CREATE TABLE AuctionEvent
(
    AuctionEventID INT IDENTITY (1,1),
    OfficiatorID INT FOREIGN KEY REFERENCES Officiators(OfficiatorID),
    AuctionAddress VARCHAR(400) NOT NULL,
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
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
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
    BidID INT FOREIGN KEY REFERENCES Bid(BidID),
    SellerID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductImage VARBINARY(MAX)
   -- WinningBid INT FOREIGN KEY REFERENCES
);

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
    BuyerID INT FOREIGN KEY REFERENCES Bid(BuyerID),
    --SellerID INT FOREIGN KEY REFERENCES
    ProductID INT FOREIGN KEY REFERENCES Bid(ProductID),
    VAT INT,
);

--INSERT STATEMENTS
INSERT INTO UserStatus(StatusType, TMStamp) VALUES ('Unverified', GETDATE());
INSERT INTO UserStatus(StatusType, TMStamp) VALUES ('Verified', GETDATE());
INSERT INTO UserStatus(StatusType, TMStamp) VALUES ('Blacklisted', GETDATE());



--Stored Procedure
USE Auction;
GO

CREATE PROCEDURE dbo.spInsertUserDetails
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
;
CREATE PROCEDURE dbo.spUpdateUserAddressDetails
    @UserID INT,
    @AddressLine1 VARCHAR(200),
    @AddressLine2 VARCHAR(200),
    @CITY VARCHAR(200),
    @PostalCode VARCHAR(10)
AS
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
;
CREATE PROCEDURE dbo.spUserBids
    @CurrentBid INT,
    @UserID INT
AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION

            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
        END CATCH
    END
