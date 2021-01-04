declare @kullaniciKod int
declare @tarih datetime
declare @faturaAdresi varchar(500)

DECLARE @FromDate DATETIME2(0)
DECLARE @ToDate   DATETIME2(0)

--2020 yýlýnda yapýlmýþ sipariþ listesi hazýrlanýyor
SET @FromDate = '2020-01-01 00:08:00' 
SET @ToDate = '2020-12-31 22:00:00'

DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
DECLARE @Random INT

declare @i int 
set @i = 50000 -- sipariþ sayýsý

while @i >= 0
begin

select top 1 @kullaniciKod = ID, @faturaAdresi = ADDRESS  
from [dbo].[CUSTOMERS] order by NEWID()

set @Random = ROUND(((@Seconds-1) * RAND()), 0)

SELECT @tarih = DATEADD(SECOND, @Random, @FromDate)

INSERT INTO [dbo].[ORDERS]
           ([kullaniciKod]
           ,[faturaAdresi]
           ,[siparisTarih]
           ,[toplam])
     VALUES
           (@kullaniciKod
           ,@faturaAdresi
           ,@tarih
           ,null)

set @i = @i - 1

end

--SELECT * FROM ORDERS
/*CREATE TABLE ORDERS (kullaniciKod INT,
						faturaAdresi VARCHAR(500),
						siparisTarih DATETIME,
						toplam FLOAT)*/

-- sonradan fatura kodu eklendi
--ALTER TABLE [dbo].[ORDERS] ADD faturaKod INT IDENTITY(1,1) PRIMARY KEY 
