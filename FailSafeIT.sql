USE FailSafeIT_Test;
GO

CREATE TABLE dbo.Kund (
    KundID int IDENTITY(1,1) CONSTRAINT PK_Kund PRIMARY KEY,
    Organisationsnummer char(11) NOT NULL
        CONSTRAINT UQ_Kund_Organisationsnummer UNIQUE,
    Foretagsnamn nvarchar(120) NOT NULL,
    Epost nvarchar(254) NOT NULL,
    Telefonnummer varchar(25) NOT NULL
);

USE FailSafeIT_Test;
GO

CREATE TABLE dbo.Konsult (
    KonsultID int IDENTITY(1,1) CONSTRAINT PK_Konsult PRIMARY KEY,
    Personnummer char(13) NOT NULL
        CONSTRAINT UQ_Konsult_Personnummer UNIQUE,
    Namn nvarchar(120) NOT NULL,
    Timpris decimal(10,2) NOT NULL
        CONSTRAINT CK_Konsult_Timpris CHECK (Timpris > 0),
    Specialitet nvarchar(100) NOT NULL
);

USE FailSafeIT_Test;
GO

CREATE TABLE dbo.Uppdrag (
    UppdragID int IDENTITY(1,1) CONSTRAINT PK_Uppdrag PRIMARY KEY,
    KundID int NOT NULL
        CONSTRAINT FK_Uppdrag_Kund REFERENCES dbo.Kund (KundID),
    KonsultID int NOT NULL
        CONSTRAINT FK_Uppdrag_Konsult REFERENCES dbo.Konsult (KonsultID),
    Startdatum date NOT NULL,
    Slutdatum date NOT NULL,
    Rollbeskrivning nvarchar(250) NOT NULL,
    CONSTRAINT CK_Uppdrag_Datum CHECK (Slutdatum >= Startdatum)
);

CREATE INDEX IX_Uppdrag_KundID
ON dbo.Uppdrag (KundID);


INSERT INTO dbo.Kund (Organisationsnummer, Foretagsnamn, Epost, Telefonnummer)
VALUES
    ('559000-1001', N'Nordhamn Logistik AB', N'kontakt@nordhamn.example', '010-555 01 01'),
    ('559000-1002', N'Skogsvik Energi AB', N'it@skogsvik.example', '010-555 01 02'),
    ('559000-1003', N'Stadsvy Handel AB', N'kontakt@stadsvy.example', '010-555 01 03'),
    ('559000-1004', N'Bergdala Studio AB', N'hej@bergdala.example', '010-555 01 04');



INSERT INTO dbo.Konsult (Personnummer, Namn, Timpris, Specialitet)
VALUES
    ('19920318-0001', N'Elin Holm', 1450, N'Cybersecurity'),
    ('19871009-0002', N'Samir Lind', 1325, N'DevOps'),
    ('19951122-0003', N'Alex Berg', 1200, N'C# Developer');

SELECT Namn, Timpris
FROM dbo.Konsult
WHERE Timpris > 1200
ORDER BY Timpris DESC;

SELECT k.Foretagsnamn, c.Namn AS Konsultnamn,
       u.Startdatum, u.Slutdatum
FROM dbo.Uppdrag AS u
JOIN dbo.Kund AS k ON k.KundID = u.KundID
JOIN dbo.Konsult AS c ON c.KonsultID = u.KonsultID
ORDER BY u.Startdatum, u.UppdragID

USE FailSafeIT_Test;
GO

DECLARE @Idag date = CONVERT(date, SYSDATETIME());

SELECT k.Foretagsnamn, COUNT(u.UppdragID) AS AntalAktivaUppdrag
FROM dbo.Kund AS k
LEFT JOIN dbo.Uppdrag AS u
    ON u.KundID = k.KundID
    AND @Idag BETWEEN u.Startdatum AND u.Slutdatum
GROUP BY k.KundID, k.Foretagsnamn
ORDER BY AntalAktivaUppdrag DESC, k.Foretagsnamn, k.KundID;


UPDATE dbo.Konsult
SET Timpris = 1550
WHERE Personnummer = '19920318-0001';

SELECT Namn, Timpris
FROM dbo.Konsult
WHERE Personnummer = '19920318-0001';

DELETE k
FROM dbo.Kund AS k
WHERE k.Organisationsnummer = '559000-1004'
  AND NOT EXISTS (
      SELECT 1
      FROM dbo.Uppdrag AS u
      WHERE u.KundID = k.KundID
  );

SELECT Foretagsnamn
FROM dbo.Kund
ORDER BY Foretagsnamn;