declare @cisim nvarchar(50)
declare @csoyisim nvarchar(50)
declare @adress nvarchar(500)
declare @caddeSokak nvarchar(100)
declare @þehir nvarchar(50)
declare @ilçe nvarchar(50)
declare @index int 

set @index = 1
while @index < 197001
begin

if RAND() < 0.5
begin
set @caddeSokak = convert(nvarchar, convert(int, RAND() * 3000 + 50)) + '. Sokak '
end
else 
begin
select top 1 @cisim = NAME_ from NAMES order by NEWID()
select top 1 @csoyisim = SURNAME from SURNAMES order by NEWID()
set @caddeSokak = CONCAT_WS(' ', @cisim, @csoyisim, 'Caddesi')
end

select @adress =  concat_ws(' ', trim([MAHALLE]), @caddeSokak,trim([SEMT])),
@ilçe = trim([ÝLÇE]),
@þehir = trim([ÞEHÝR])
from [dbo].[ADDRESSTYPE] order by NEWID()
print(@adress)

update CUSTOMERS
set ADDRESS = @adress, CITY = @þehir, TOWN = @ilçe
where ID = @index;

set @index = @index + 1
end
--select * from [dbo].[ADDRESSTYPE]
--select count(*) from CUSTOMERS
--ALTER TABLE [dbo].[CUSTOMERS] ADD ADDRESS VARCHAR(500)

select count(ADDRESS) FROM CUSTOMERS
SELECT * FROM CUSTOMERS