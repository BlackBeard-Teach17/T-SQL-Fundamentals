USE MovieDB;
GO

--Create our main movie table
CREATE TABLE [dbo].[Movies](
	[MovieID] [int] IDENTITY(1,1) NOT NULL,
	[MovieName] [varchar] (120) NULL,
	[ReleaseDate] [date] NULL,
	[RunningTime] [int] NULL,
	[MovieDescription] [varchar](8000) NULL,
	[Genre] [varchar](1000) NULL
	);
	GO

--add movieID as the PK
ALTER TABLE [dbo].[Movies]
	ADD CONSTRAINT [PK_Movies] PRIMARY KEY CLUSTERED ([MovieID] ASC);
GO

--Insert into Movies table
INSERT INTO [dbo].[Movies] ([MovieName], [ReleaseDate], [RunningTime], [MovieDescription], [Genre])
VALUES	('Ghostbusters','8 June 1984',105,'','Comedy, Horror'),
		('Dances With Wolves','21 November 1990', 181,'', 'Drama, Western, Romance'),
		('Aliens','18 July 1986', 137,'', 'Action, Horror, Drama, Science Fiction'),
		('Bladerunner','25 June 1982', 117,'', 'Science Fiction, Drama'),
		('Prometheus','8 June 2012', 124,'', 'Drama, Science Fiction, Action, Horror'),
		('Alien','22 June 1979', 117,'', 'Horror, Suspense, Science Fiction'),
		('Groundhog Day','12 February 1993', 101,'', 'Comedy, Romance'),
		('The Matrix','31 March 1999', 136,'', 'Science Fiction, Action')
GO

CREATE VIEW vMovies
AS
SELECT [MovieName],
[ReleaseDate],
[RunningTime],
[MovieDescription],
[Genre]
FROM Movies
GO

--Create a table for Actors
CREATE TABLE [dbo].[Actors](
	[ActorID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[FirstName] [varchar](200) NOT NULL,
	[LastName] [varchar] (200) NULL,
	[DateOfBirth] [date] NULL,
	[MovieID] [int] FOREIGN KEY REFERENCES [Movies]([MovieID])

	);
 --Insert into Actors table
 INSERT INTO [dbo].[Actors] ([MovieID], [FirstName], [LastName], [DateOfBirth])

VALUES	(1, 'Bill','Murray','21 September 1950'),
		(1, 'Dan', 'Aykroyd','1 July 1952'), 
		(1, 'Sigourney', 'Weaver', '8 October 1949'),
		(1, 'Harold', 'Ramis', '21 November 1944'),
		(1, 'Rick', 'Moranis', '18 April 1953'),
		(1, 'Ernie', 'Hudson','17 December 1945'),
		(2, 'Kevin', 'Costner','18 January 1955'),
		(2, 'Mary', 'McDonnell','28 April 1952'),
		(3, 'Sigourney', 'Weaver', '8 October 1949'),
		(3, 'Michael', 'Biehn', '31 July 1956'),
		(3, 'Paul', 'Reiser','30 March 1957'),
		(3, 'Lance', 'Henriksen','5 May 1940'),
		(3, 'Bill', 'Paxton','17 May 1955'),
		(4, 'Harrison', 'Ford','13 July 1942'),
		(4, 'Rutger', 'Hauer','23 January 1944'),
		(4, 'Sean', 'Young','20 November 1959'),
		(4, 'Daryl', 'Hannah','3 December 1960'),
		(5, 'Noomi', 'Rapace','28 December 1979'),
		(5, 'Michael', 'Fassbender','2 April 1977'),
		(5, 'Charlize', 'Theron','7 August 1975'),
		(5, 'Idris', 'Elba','6 September 1972'),
		(5, 'Guy', 'Pearce','5 October 1967'),
		(6, 'Tom', 'Skerritt','25 August 1933'),
		(6, 'Sigourney', 'Weaver','8 October 1949'),
		(6, 'Veronica', 'Cartwright','20 April 1949'),
		(6, 'John', 'Hurt','22 January 1940'),
		(6, 'Ian', 'Holm','12 September 1931'),
		(6, 'Yaphet', 'Kotto','15 November 1939'),
		(7, 'Bill', 'Murray','21 September 1950'),
		(7, 'Andie', 'MacDowell','21 April 1958'),
		(7, 'Chris', 'Elliott','31 May 1960'),
		(7, 'Stephen', 'Tobolowsky','30 May 1951'),
		(7, 'Harold', 'Ramis','21 November 1944'),
		(8, 'Keanu', 'Reeves','2 September 1964'),
		(8, 'Laurence', 'Fishburne','30 July 1961'),
		(8, 'Carrie-Anne', 'Moss','21 August 1967'),
		(8, 'Hugo', 'Weaving','4 April 1960'),
		(8, 'Joe', 'Pantoliano','12 September 1951')
	
GO

--Add field to movies table to store poster
ALTER TABLE [dbo].[Movies]
	ADD [MoviePoster] [verbinary] (MAX);
GO

--Add actor image in actors table
ALTER TABLE [dbo].[Actors]
	ADD [ActorPoster] [verbinary] (MAX);
GO

--Add place of birth and country of birth
ALTER TABLE [dbo].[Actors]
	ADD [PlaceOfBirth] [varchar] (300) NULL;
GO

ALTER TABLE [dbo].[Actors]
	 ADD [CountryOfBirth] [varchar](300) NULL;
GO

--Update Actors Table
UPDATE [dbo].[Actors] SET [PlaceOfBirth] = 'Sidney', [CountryOfBirth] = 'Australia';
GO

CREATE TABLE [dbo].[ActorUpdates] (
		[MovieID] [INT] NULL,
		[FirstName] [VARCHAR](80) NULL,
		[LastName] [VARCHAR](120) NULL,
		[DateOfBirth] [DATE] NULL,
		[PlaceOfBirth] [VARCHAR](80) NULL,
		[CountryOfBirth] [VARCHAR](100) NULL
)
GO

INSERT INTO [dbo].[ActorUpdates] (	[MovieID], 
								[FirstName], 
								[LastName], 
								[DateOfBirth], 
								[PlaceOfBirth], 
								[CountryOfBirth]
							)
VALUES	(1, 'Bill','Murray','21 September 1950','Chicago','USA'),
		(1, 'Dan', 'Aykroyd','1 July 1952','Ontario','Canada'), 
		(1, 'Sigourney', 'Weaver', '8 October 1949','New York','USA'),
		(1, 'Harold', 'Ramis', '21 November 1944','Chicago','USA'),
		(1, 'Rick', 'Moranis', '18 April 1953','Ontario','Canada'),
		(1, 'Ernie', 'Hudson','17 December 1945','Michigan','USA'),
		(2, 'Kevin', 'Costner','18 January 1955','California','USA'),
		(2, 'Mary', 'McDonnell','28 April 1952','Pennsylvania','USA'),
		(3, 'Sigourney', 'Weaver', '8 October 1949','New York','USA'),
		(3, 'Michael', 'Biehn', '31 July 1956','Alabama','USA'),
		(3, 'Paul', 'Reiser','30 March 1957','New York','USA'),
		(3, 'Lance', 'Henriksen','5 May 1940','New York','USA'),
		(3, 'Bill', 'Paxton','17 May 1955','Texas','USA'),
		(4, 'Harrison', 'Ford','13 July 1942','Chicago','USA'),
		(4, 'Rutger', 'Hauer','23 January 1944','Utrecht','Netherlands'),
		(4, 'Sean', 'Young','20 November 1959','Kentucky','USA'),
		(4, 'Daryl', 'Hannah','3 December 1960','Chicago','USA'),
		(5, 'Noomi', 'Rapace','28 December 1979','Hudiksvall','Sweden'),
		(5, 'Michael', 'Fassbender','2 April 1977','Heidelberg','West Germany'),
		(5, 'Charlize', 'Theron','7 August 1975','Benoni','South Africa'),
		(5, 'Idris', 'Elba','6 September 1972','London','UK'),
		(5, 'Guy', 'Pearce','5 October 1967','Cambridgeshire','UK'),
		(6, 'Tom', 'Skerritt','25 August 1933','Michigan','USA'),
		(6, 'Sigourney', 'Weaver','8 October 1949','New York','USA'),
		(6, 'Veronica', 'Cartwright','20 April 1949','Bristol','UK'),
		(6, 'John', 'Hurt','22 January 1940','Derbyshire','UK'),
		(6, 'Ian', 'Holm','12 September 1931','Essex','UK'),
		(6, 'Yaphet', 'Kotto','15 November 1939','New York','USA'),
		(7, 'Bill', 'Murray','21 September 1950','Chicago','USA'),
		(7, 'Andie', 'MacDowell','21 April 1958','South Carolina','USA'),
		(7, 'Chris', 'Elliott','31 May 1960','New York','USA'),
		(7, 'Stephen', 'Tobolowsky','30 May 1951','Dallas','USA'),
		(7, 'Harold', 'Ramis','21 November 1944','Chicago','USA'),
		(8, 'Keanu', 'Reeves','2 September 1964','Beirut','Lebanon'),
		(8, 'Laurence', 'Fishburne','30 July 1961','Georgia','USA'),
		(8, 'Carrie-Anne', 'Moss','21 August 1967','Vancouver', 'Canada'),
		(8, 'Hugo', 'Weaving','4 April 1960','Ibadan','Nigeria'),
		(8, 'Joe', 'Pantoliano','12 September 1951','New Jersey','USA'),
		(8, 'Matt', 'Doran','30 March 1976','Sidney','Australia')

GO

MERGE [dbo].[Actors]
USING [ActorUpdates]
ON [Actors].[FirstName] = [ActorUpdates].[FirstName]
AND [Actors].[LastName] = [ActorUpdates].[LastName]
AND [Actors].[MovieID] = [ActorUpdates].[MovieID]
WHEN MATCHED AND
  [ActorUpdates].[FirstName] IS NOT NULL THEN
  UPDATE
	SET	[Actors].[PlaceOfBirth] = [ActorUpdates].[PlaceOfBirth],
		[Actors].[CountryOfBirth] = [ActorUpdates].[CountryOfBirth]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (MovieID, [FirstName], [LastName], [BirthDate], [PlaceOfBirth], [CountryOfBirth])
  VALUES (	ActorUpdates.[MovieID], ActorUpdates.[FirstName], ActorUpdates.[LastName], ActorUpdates.[DateOfBirth], ActorUpdates.[PlaceOfBirth], ActorUpdates.[CountryOfBirth]);
GO

--Directors table
CREATE TABLE [dbo].[Directors](
	[FirstName] [varchar](200) NOT NULL,
	[LastName] [varchar](200) NULL,
	[DateOfBirth] [date],
	[PlaceOfBirth] [varchar](200) NULL,
	[CountryOfBirth][varchar](200) NULL,
	[Image] [binary],
	[DirectorID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[MovieID][int] FOREIGN KEY REFERENCES [Movies]([MovieID])
);

--Add DOB check
ALTER TABLE [dbo].[Directors]
	ADD CHECK (DateOfBirth < GETDATE());
GO

--ALTER TABLE [dbo].[Directors] WITH CHECK ADD CONSTRAINT [CK_DirectorBirthDate] CHECK  (([BirthDate]<getdate()))

--Film Writers table
CREATE TABLE [dbo].[Writers](
	[FirstName][varchar](200) NULL,
	[LastName][varchar](200) NULL,
	[DateOfBirth][date],
	[Age][int] NULL,
	[PlaceOfBirth][varchar](300) NULL,
	[CountryOfBirth][varchar](300) NULL,
	[Image][binary],
	[WriterID][int] IDENTITY(1,1) NOT NULL,
	[MovieID][int] FOREIGN KEY REFERENCES [Movies]([MovieID])
	CONSTRAINT [PK_Writers] PRIMARY KEY CLUSTERED 
	(
		[WriterID] ASC
	)
);

--Check directors DOB < todays date
ALTER TABLE [dbo].[Writers]
	WITH CHECK ADD CONSTRAINT [CK_DirectorDOB] CHECK (DateOfBirth < GETDATE());
GO

CREATE TABLE [dbo].[Producers](
	[FirstName][varchar](200) NULL,
	[LastName][varchar](200) NULL,
	[DateOfBirth][date],
	[Age][int] NULL,
	[PlaceOfBirth][varchar](300) NULL,
	[CountryOfBirth][varchar](300) NULL,
	[FilmImage][binary],
	[ProducerID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[MovieID][int] FOREIGN KEY REFERENCES [Movies]([MovieID])
);

ALTER TABLE [dbo].[Producers]
	ADD CHECK (DateOfBirth < GETDATE());
GO

ALTER TABLE [dbo].[Writers]
	DROP COLUMN Age;
GO

DROP TABLE [Producers];

CREATE TABLE [dbo].[Producers](
	[FirstName][varchar](200) NULL,
	[LastName][varchar](200) NULL,
	[DateOfBirth][date],
	[PlaceOfBirth][varchar](300) NULL,
	[CountryOfBirth][varchar](300) NULL,
	[FilmImage][binary],
	[ProducerID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[MovieID][int] FOREIGN KEY REFERENCES [Movies]([MovieID])
);

MERGE [dbo].[Directors]
USING 
(
	SELECT	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth]
	FROM
	(
	VALUES	(1,'Ivan','Reitman', '27 October 1946', 'Komárno','Slovak Republic'),
			(2,'Kevin','Costner', '18 January 1955', 'California','USA'),
			(3,'James','Cameron', '16 August 1954', 'Ontario','Canada'),
			(4,'Ridley','Scott', '30 November 1937', 'England','UK'),
			(5,'Ridley','Scott', '30 November 1937', 'England','UK'),
			(6,'Ridley','Scott', '30 November 1937', 'England','UK'),
			(7,'Harold','Ramis', '21 November 1944', 'Chicago','USA'),
			(8,'Lana','Wachowski', '21 June 1965', 'Chicago','USA'),
			(8,'Lilly','Wachowski', '29 December 1967', 'Chicago','USA') 
	) AS X (	[MovieID], 
				[FirstName], 
				[LastName], 
				[DateOfBirth], 
				[PlaceOfBirth], 
				[CountryOfBirth]
			) 
) AS [DirectorUpdates]
ON [Directors].[FirstName] = [DirectorUpdates].[FirstName]
AND [Directors].[LastName] = [DirectorUpdates].[LastName]
AND [Directors].[MovieID] = [DirectorUpdates].[MovieID]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth])
  VALUES (	[DirectorUpdates].[MovieID], 
			[DirectorUpdates].[FirstName], 
			[DirectorUpdates].[LastName], 
			[DirectorUpdates].[DateOfBirth], 
			[DirectorUpdates].[PlaceOfBirth], 
			[DirectorUpdates].[CountryOfBirth]);
GO


-- Producers
MERGE [dbo].[Producers]
USING 
(
	SELECT	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth]
	FROM
	(
	VALUES	(1,'Ivan','Reitman', '27 October 1946', 'Komárno','Slovak Republic'),
			(2,'Kevin','Costner', '18 January 1955', 'California','USA'),
			(3,'James','Cameron', '16 August 1954', 'Ontario','Canada'),
			(4,'Michael','Deeley', '6 August 1932', 'London','UK'),
			(4,'Hampton','Fancher', '18 July 1938', 'California','USA'),
			(5,'David','Giler', '15 September 1948', 'New York','USA'),
			(5,'Walter','Hill', '10 January 1942', 'California','USA'),
			(5,'Ridley','Scott', '30 November 1937', 'England','UK'),
			(6,'Gordon','Carroll', '15 September 1959', 'New York','USA'),
			(6,'David','Giler', '15 September 1948', 'New York','USA'),
			(6,'Walter','Hill', '10 January 1942', 'California','USA'),
			(7,'Trevor','Albert', '15 September 1959', 'New York','USA'),
			(7,'Harold','Ramis', '21 November 1944', 'Chicago','USA'),
			(8,'Joel','Silver', '14 July 1952', 'New Jersey','USA'),
			(8,'Lana','Wachowski', '21 June 1965', 'Chicago','USA'),
			(8,'Lilly','Wachowski', '29 December 1967', 'Chicago','USA')
	) AS X (	[MovieID], 
				[FirstName], 
				[LastName], 
				[DateOfBirth], 
				[PlaceOfBirth], 
				[CountryOfBirth]
			) 
) AS [ProducerUpdates]
ON [Producers].[FirstName] = [ProducerUpdates].[FirstName]
AND [Producers].[LastName] = [ProducerUpdates].[LastName]
AND [Producers].[MovieID] = [ProducerUpdates].[MovieID]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth])
  VALUES (	[ProducerUpdates].[MovieID], 
			[ProducerUpdates].[FirstName], 
			[ProducerUpdates].[LastName], 
			[ProducerUpdates].[DateOfBirth], 
			[ProducerUpdates].[PlaceOfBirth], 
			[ProducerUpdates].[CountryOfBirth]);
GO


-- Writers
MERGE [dbo].[Writers]
USING 
(
	SELECT	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth]
	FROM
	(			
	VALUES	(1,'Dan','Aykroyd', '1 July 1952', 'New York','USA'),
			(1,'Harold','Ramis', '21 November 1944', 'Chicago','USA'),
			(2,'Michael','Blake', '5 July 1945', 'North Carolina','USA'),
			(3,'James','Cameron', '16 August 1954', 'Ontario','Canada'),
			(3,'David','Giler', '15 September 1948', 'New York','USA'),
			(4,'Hampton','Fancher', '18 July 1938', 'California','USA'),
			(4,'David','Peoples', '15 September 1940', 'Connecticut','USA'),
			(4,'Philip K','Dick', '16 December 1928', 'Chicago','USA'),
			(5,'Jon','Spaihts', '15 September 1959', 'New York','USA'),
			(5,'Damon','Lindelof', '24 April 1973', 'New Jersey','USA'),
			(6,'Dan','O''Bannon', '30 September 1946', 'Missouri','USA'),
			(6,'Ronald','Shusett', '15 September 1959', 'New York','USA'),
			(7,'Danny','Rubin', '15 September 1957', 'New York','USA'),
			(7,'Harold','Ramis', '21 November 1944', 'Chicago','USA'),
			(8,'Lana','Wachowski', '21 June 1965', 'Chicago','USA'),
			(8,'Lilly','Wachowski', '29 December 1967', 'Chicago','USA')
	) AS X (	[MovieID], 
				[FirstName], 
				[LastName], 
				[DateOfBirth], 
				[PlaceOfBirth], 
				[CountryOfBirth]
			) 
) AS [WriterUpdates]
ON [Writers].[FirstName] = [WriterUpdates].[FirstName]
AND [Writers].[LastName] = [WriterUpdates].[LastName]
AND [Writers].[MovieID] = [WriterUpdates].[MovieID]
WHEN NOT MATCHED BY TARGET THEN
  INSERT (	[MovieID], 
			[FirstName], 
			[LastName], 
			[DateOfBirth], 
			[PlaceOfBirth], 
			[CountryOfBirth])
  VALUES (	[WriterUpdates].[MovieID], 
			[WriterUpdates].[FirstName], 
			[WriterUpdates].[LastName], 
			[WriterUpdates].[DateOfBirth], 
			[WriterUpdates].[PlaceOfBirth], 
			[WriterUpdates].[CountryOfBirth]);
GO

--DROP DATABASE MovieDB

