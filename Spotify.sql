CREATE DATABASE MusicApp

USE MusicApp

CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50),
    Surname NVARCHAR(50),
    Username NVARCHAR(50),
    Password NVARCHAR(20) NULL,
    Gender NVARCHAR(10) NULL
);

CREATE TABLE Artists (
    id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50),
    Surname NVARCHAR(50),
    Birthday DATETIME NULL,
    Gender NVARCHAR(10) NULL
);

CREATE TABLE Categories (
    id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50)
);

CREATE TABLE Musics (
    id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(50),
    Duration DECIMAL,
    ArtistId INT FOREIGN KEY REFERENCES Artists(id),
    CategoryId INT FOREIGN KEY REFERENCES Categories(id),
    IsDeleted BIT DEFAULT (0) NOT NULL
);

CREATE TABLE Playlists (
    id INT PRIMARY KEY IDENTITY(1,1),
    UserId INT FOREIGN KEY REFERENCES Users(id),
    MusicId INT FOREIGN KEY REFERENCES Musics(id)
);


INSERT INTO Users (Name, Surname, Username, Password, Gender)
VALUES
    ('Murad', 'Khasaddinov', 'MurEdu2003', 'forgot23', 'Male'),
    ('Subhan', 'Amiraslanov', 'Adolf', 'hail123', 'Female'),
    ('Vagif', 'Qarayev', 'notNasirli', 'qaraqarayev', 'Male');

INSERT INTO Artists (Name, Surname, Birthday, Gender)
VALUES
    ('Rashid', 'Behbudov', '1958-08-29', 'Male'),
    ('Katy', 'Perry', '2000-05-05', 'Female'),
    ('Engelbert', 'Humperdinck', '1947-03-25', 'Male');

INSERT INTO Categories (Name)
VALUES
    ('Pop'),
    ('Rock'),
    ('Classical');

INSERT INTO Musics (Name, Duration, ArtistId, CategoryId)
VALUES
    ('Nazende Sevgilim', 5.42, 1, 3),
    ('Roar', 4.55, 2, 1),
    ('A Man Without Love', 4.42, 3, 2);

INSERT INTO Playlists (UserId, MusicId)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- View
CREATE VIEW MusicInfo AS
SELECT
    M.Name AS MusicName,
    M.Duration AS MusicLength,
    C.Name AS MusicCategory,
    CONCAT(A.Name, ' ', A.Surname) AS ArtistName
FROM Musics M
INNER JOIN Categories C ON M.CategoryId = C.id
INNER JOIN Artists A ON M.ArtistId = A.id;


CREATE PROCEDURE usp_CreateMusic (
    @Name NVARCHAR(50),
    @Duration DECIMAL,
    @ArtistId INT,
    @CategoryId INT
)
AS
BEGIN 
    INSERT INTO Musics (Name, Duration, ArtistId, CategoryId)
    VALUES (@Name, @Duration, @ArtistId, @CategoryId);
END

CREATE PROCEDURE usp_GetMusicById (
    @MusicId INT
)
AS
BEGIN
    SELECT * FROM Musics
    WHERE id = @MusicId;
END

CREATE PROCEDURE usp_DeleteMusic (
    @MusicId INT
)
AS
BEGIN 
    DELETE FROM Musics
    WHERE id = @MusicId;
END

CREATE PROCEDURE usp_GetAllMusics
AS
BEGIN
    SELECT * FROM Musics;
END


CREATE PROCEDURE usp_CreateArtist (
    @Name NVARCHAR(50),
    @Surname NVARCHAR(50),
    @Birthday DATETIME,
    @Gender NVARCHAR(10)
)
AS
BEGIN 
    INSERT INTO Artists (Name, Surname, Birthday, Gender)
    VALUES (@Name, @Surname, @Birthday, @Gender);
END

CREATE PROCEDURE usp_GetArtistById (
    @ArtistId INT
)
AS
BEGIN
    SELECT * FROM Artists
    WHERE id = @ArtistId;
END

CREATE PROCEDURE usp_DeleteArtist (
    @ArtistId INT
)
AS
BEGIN 
    DELETE FROM Artists
    WHERE id = @ArtistId;
END

CREATE PROCEDURE usp_GetAllArtists
AS
BEGIN
    SELECT * FROM Artists;
END

--==================== Triggers =======================--
CREATE TRIGGER trg_MusicDeletion
ON Musics
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedMusicId INT;
    SELECT @DeletedMusicId = id FROM DELETED;

    IF (SELECT IsDeleted FROM Musics WHERE id = @DeletedMusicId) = 0
    BEGIN
        UPDATE Musics
        SET IsDeleted = 1
        WHERE id = @DeletedMusicId;

        IF (SELECT IsDeleted FROM Musics WHERE id = @DeletedMusicId) = 1
        BEGIN
            DELETE FROM Musics WHERE id = @DeletedMusicId;
        END
    END
END;


EXEC usp_CreateMusic @Name = 'After Dark', @Duration = 4.30, @ArtistId = 1, @CategoryId = 2;

EXEC usp_CreateUser @Name = 'Adil', @Surname = 'Mellimov', @Username = 'Backend Enthusiast', @Password = 'birthdaynumber', @Gender = 'Male';

EXEC usp_CreateCategory @Name = 'Heavy Metal';
