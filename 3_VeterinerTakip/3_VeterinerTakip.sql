/* =====================================================
PROJE ADI: Veteriner Takip Sistemi
ÖĞRENCİLER: Sıla Yücel, Rabia Ravza Çolak, İrem İlknur Kocakoç
===================================================== */

-- Veritabanı oluşturma işlemleri
USE master;
GO

-- Eğer veritabanı varsa sil 
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'VeterinerTakipDB')
BEGIN
    ALTER DATABASE VeterinerTakipDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VeterinerTakipDB;
END
GO

CREATE DATABASE VeterinerTakipDB;
GO
USE VeterinerTakipDB;
GO

/* =====================================================
TABLOLARIN OLUŞTURULMASI
===================================================== */

-- Musteri Tablosu: Müşteri bilgilerini tutar.
-- MusteriID: Her müşteriyi benzersiz şekilde tanımlar (PRIMARY KEY)
-- Telefon: UNIQUE kısıtlaması ile her müşterinin farklı telefon numarası olmasını sağlar
CREATE TABLE Musteri(
    MusteriID INT PRIMARY KEY IDENTITY(1,1),  -- Otomatik artan benzersiz ID
    AdiSoyadi NVARCHAR(100) NOT NULL,          -- Müşteri adı soyadı (boş olamaz)
    Telefon NVARCHAR(15) UNIQUE NOT NULL,      -- Telefon (benzersiz ve boş olamaz)
    Mail NVARCHAR(100) NOT NULL                -- E-posta adresi (boş olamaz)
);
GO

-- Hayvanlar Tablosu: Müşterilere ait hayvan bilgilerini tutar.
-- HayvanID: Her hayvanı benzersiz şekilde tanımlar
-- Yas: CHECK ile negatif değer girilmesini engeller (Yaş >= 0)
-- MusteriID: FOREIGN KEY ile Musteri tablosuna bağlanır (Her hayvanın bir sahibi olmalı)
CREATE TABLE Hayvanlar(
    HayvanID INT PRIMARY KEY IDENTITY(1,1),
    Adi NVARCHAR(100) NOT NULL,                -- Hayvan adı
    Tur NVARCHAR(50) NOT NULL,                 -- Hayvan türü (Kedi, Köpek, Kuş vb.)
    Cins NVARCHAR(50) NOT NULL,                -- Hayvan cinsi
    Cinsiyet NVARCHAR(50) NOT NULL,            -- Cinsiyet (Erkek/Dişi)
    Yas INT NOT NULL CHECK (Yas >= 0),         -- Yaş (0'dan küçük olamaz)
    MusteriID INT NOT NULL,                    -- Hangi müşteriye ait olduğu
    FOREIGN KEY (MusteriID) REFERENCES Musteri(MusteriID)  -- Musteri tablosuyla ilişki
);
GO

-- Veteriner Tablosu: Veteriner hekim bilgilerini tutar.
-- VeterinerID: Her veterineri benzersiz şekilde tanımlar
-- VeterinerTC: UNIQUE ile her veterinerin TC'sinin benzersiz olmasını sağlar
CREATE TABLE Veteriner(
    VeterinerID INT PRIMARY KEY IDENTITY(1,1),
    VeterinerTC NVARCHAR(100) UNIQUE NOT NULL, -- TC Kimlik Numarası (benzersiz)
    AdiSoyadi NVARCHAR(100) NOT NULL,           -- Ad soyad
    Mail NVARCHAR(100) NOT NULL,                -- E-posta
    Telefon NVARCHAR(100) NOT NULL,             -- Telefon
    Maas DECIMAL(10,2) NOT NULL,                -- Maaş (10 haneli, 2 ondalık)
    UzmanlikAlani NVARCHAR(100) NOT NULL        -- Uzmanlık alanı
);
GO

-- Kayit Tablosu: Hayvanlara yapılan muayene kayıtlarını tutar.
-- KayitID: Her kaydı benzersiz şekilde tanımlar
-- KayitTarihi: DEFAULT GETDATE() ile kayıt oluşturulduğunda otomatik olarak günün tarihini alır
-- HayvanID ve VeterinerID: FOREIGN KEY ile diğer tablolara bağlanır
CREATE TABLE Kayit(
    KayitID INT PRIMARY KEY IDENTITY(1,1),
    KayitTarihi DATE NOT NULL DEFAULT GETDATE(), -- Kayıt tarihi (otomatik olarak bugünün tarihi)
    Sikayet NVARCHAR(100) NOT NULL,              -- Müşterinin şikayeti
    Teshis NVARCHAR(100) NOT NULL,               -- Veterinerin teşhisi
    Ucreti DECIMAL(10,2) NOT NULL,               -- Muayene ücreti
    HayvanID INT NOT NULL,                       -- Hangi hayvana ait
    VeterinerID INT NOT NULL,                    -- Hangi veteriner tarafından
    FOREIGN KEY (HayvanID) REFERENCES Hayvanlar(HayvanID),
    FOREIGN KEY (VeterinerID) REFERENCES Veteriner(VeterinerID)
);
GO 

/* =====================================================
VERİ EKLEME İŞLEMLERİ (INSERT)
===================================================== */

-- Musteri tablosuna örnek veriler eklenir
INSERT INTO Musteri(AdiSoyadi, Telefon, Mail) VALUES 
    (N'Rabia Ravza Çolak', '05321112233', 'rabia@mail.com'),
    (N'Ayşe Demir', '05432223344', 'ayse@mail.com'),
    (N'Ahmet Şentürk', '05553334455', 'ahmet@mail.com'),
    (N'Hasan Ali Yücel', '05054445566', 'hasanali@mail.com'),
    (N'Talha Kocakoç', '05335556677', 'talha@mail.com');
GO

-- Hayvanlar tablosuna örnek veriler eklenir
INSERT INTO Hayvanlar(Adi, Tur, Cins, Cinsiyet, Yas, MusteriID) VALUES 
    (N'Şampiyon', N'Papağan', N'Sultan Papağanı', N'Dişi', 2, 1),
    (N'Karabaş', N'Köpek', N'Sivas Kangalı', N'Erkek', 4, 2),
    (N'Maviş', N'Kuş', N'Muhabbet Kuşu', N'Erkek', 1, 3),
    (N'Duman', N'Kedi', N'British Shorthair', N'Erkek', 3, 1),
    (N'Gofret', N'Köpek', N'Golden Retriever', N'Dişi', 5, 4);
GO

-- Veteriner tablosuna örnek veriler eklenir
INSERT INTO Veteriner(VeterinerTC, AdiSoyadi, Mail, Telefon, Maas, UzmanlikAlani) VALUES 
    ('12345678901', N'Dr. Selim Ak', 'selim@klinik.com', '05123456789', 95000.00, N'Cerrahi'),
    ('23456789012', N'Dr. Elif Çelik', 'elif@klinik.com', '05234567890', 92000.00, N'Küçük Hayvan Hekimliği'),
    ('34567890123', N'Dr. Murat Aydın', 'murat@klinik.com', '05345678901', 90000.00, N'Egzotik Hayvanlar'),
    ('45678901234', N'Dr. Seda Yurt', 'seda@klinik.com', '05456789012', 96000.00, N'Doğum ve Jinekoloji'),
    ('56789012345', N'Dr. Hakan Avcı', 'hakan@klinik.com', '05567890123', 91000.00, N'Dermatoloji');
GO

-- Kayit tablosuna örnek veriler eklenir (KayitTarihi DEFAULT ile otomatik gelecek)
INSERT INTO Kayit(Sikayet, Teshis, Ucreti, HayvanID, VeterinerID) VALUES 
    (N'Genel Kontrol', N'Hayvan Sağlıklı', 1500.00, 1, 1),
    (N'Topallama', N'Doku Zedelenmesi', 2000.00, 2, 1),
    (N'Tüy Dökülmesi', N'Mantar Enfeksiyonu', 1200.00, 4, 5),
    (N'Halsizlik', N'Soğuk Algınlığı', 1000.00, 5, 2),
    (N'İştahsızlık', N'Gıda Zehirlenmesi', 800.00, 3, 3);
GO

/* =====================================================
 SELECT SORGULARI
===================================================== */

-- Tüm müşterilerin ad ve telefon bilgilerini listele
SELECT AdiSoyadi, Telefon FROM Musteri;

-- 2 yaşından büyük hayvanların ad, tür ve yaş bilgilerini listele
SELECT Adi, Tur, Yas FROM Hayvanlar WHERE Yas > 2;

-- Maaşı 92000'den yüksek olan veterinerlerin ad, uzmanlık ve maaş bilgilerini listele
SELECT AdiSoyadi, UzmanlikAlani, Maas FROM Veteriner WHERE Maas > 92000;

-- Tüm kayıtların teşhis ve ücret bilgilerini listele
SELECT Teshis, Ucreti FROM Kayit;

-- Kedi türündeki hayvanların ad ve cins bilgilerini listele
SELECT Adi, Cins FROM Hayvanlar WHERE Tur = N'Kedi';
GO

/* =====================================================
JOIN SORGULARI (Tablolar arası ilişki kurma)
===================================================== */

-- Hayvanlar ve sahiplerini listele (INNER JOIN)
SELECT h.Adi AS HayvanAdi, m.AdiSoyadi AS Sahibi 
FROM Hayvanlar h 
JOIN Musteri m ON h.MusteriID = m.MusteriID;

-- Kayıtlar, hayvanlar ve veterinerleri birlikte listele 
SELECT h.Adi AS HayvanAdi, v.AdiSoyadi AS VeterinerAdi, k.Teshis 
FROM Kayit k 
JOIN Hayvanlar h ON k.HayvanID = h.HayvanID 
JOIN Veteriner v ON k.VeterinerID = v.VeterinerID;

-- Tüm müşterileri ve varsa hayvanlarını listele (LEFT JOIN - hayvanı olmayanlar da gelsin)
SELECT m.AdiSoyadi, h.Adi AS HayvanAdi 
FROM Musteri m 
LEFT JOIN Hayvanlar h ON m.MusteriID = h.MusteriID;
GO

/* =====================================================
GROUP BY ve HAVING SORGULARI 
===================================================== */

-- Her türe göre hayvan sayısını listele
SELECT Tur, COUNT(*) AS ToplamSayi FROM Hayvanlar GROUP BY Tur;

-- Her veterinerin toplam kazancını listele
SELECT VeterinerID, SUM(Ucreti) AS ToplamKazanc FROM Kayit GROUP BY VeterinerID;

-- Toplam kazancı 1500'den fazla olan veterinerleri listele (HAVING ile gruplara şart)
SELECT VeterinerID, SUM(Ucreti) AS ToplamKazanc 
FROM Kayit 
GROUP BY VeterinerID 
HAVING SUM(Ucreti) > 1500;
GO

/* =====================================================
ALT SORGU ÖRNEKLERİ
===================================================== */

-- Maaşı ortalama maaştan yüksek olan veterinerleri listele
SELECT AdiSoyadi, Maas 
FROM Veteriner 
WHERE Maas > (SELECT AVG(Maas) FROM Veteriner);

-- En az bir kaydı olan hayvanları listele
SELECT Adi, Tur 
FROM Hayvanlar 
WHERE HayvanID IN (SELECT HayvanID FROM Kayit);
GO

/* =====================================================
VIEW (Sanal Tablo) Oluşturma
===================================================== */

-- Sık kullanılan JOIN sorgularını sanal tabloya kaydet
CREATE VIEW DetayliRapor AS
SELECT 
    k.KayitID, 
    h.Adi AS Hayvan, 
    v.AdiSoyadi AS Veteriner, 
    k.Teshis,
    k.Ucreti,
    k.KayitTarihi
FROM Kayit k 
JOIN Hayvanlar h ON k.HayvanID = h.HayvanID 
JOIN Veteriner v ON k.VeterinerID = v.VeterinerID;
GO

-- View'i kullanarak detaylı raporu görüntüle
SELECT * FROM DetayliRapor;
GO

/* =====================================================
                 INDEX Oluşturma 
===================================================== */

-- Hayvan türüne göre aramaları hızlandırmak için index oluştur
CREATE INDEX IX_HayvanTur ON Hayvanlar(Tur);
GO

/* =====================================================
STORED PROCEDURE Oluşturma
===================================================== */

-- Tüm kedileri listeleyen prosedür
CREATE PROCEDURE sp_KediListesi
AS
BEGIN
    SELECT * FROM Hayvanlar WHERE Tur = N'Kedi';
END;
GO

-- Prosedürü çalıştır
EXEC sp_KediListesi;
GO

/* =====================================================
TRANSACTION (İşlem) Yönetimi
===================================================== */

-- Yeni müşteri ekleme işlemini transaction ile yap
BEGIN TRANSACTION;
    INSERT INTO Musteri (AdiSoyadi, Telefon, Mail) 
    VALUES (N'Sıla Yücel', '05999999999', 'sila@mail.com');
    
    -- İşlem başarılı ise onayla
    COMMIT;
GO

-- Eklenen müşteriyi kontrol et
SELECT * FROM Musteri WHERE AdiSoyadi LIKE N'Sıla%';
GO