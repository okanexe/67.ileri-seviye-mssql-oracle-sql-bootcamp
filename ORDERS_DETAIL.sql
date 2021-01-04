declare @siparisUrunAdet int

declare @urunAdet int
declare @urunliste float
declare @urunkdv float
declare @toplam float
declare @urunKod int
declare @faturaKod int

declare @fiyat float
declare @kdvfiyat float

-- where toplam is null sayesinde sonradan eklenen verilere toplam ekliyoruz.
declare cls cursor for select faturaKod from [dbo].[ORDERS] where toplam is null
open cls
fetch next from cls into @faturakod

while @@FETCH_STATUS = 0
begin
set @toplam = 0

-- max-min ne kadar ürün eklenecek
set @siparisUrunAdet = convert(int, rand() * 25 +1)

while @siparisUrunAdet > 0
begin

--seçilen üründen kaç adet eklenecek
set @urunAdet = convert(int, rand() * 10 +1)

select top 1 @urunKod = urunKod, @urunkdv = [kdvOran], @urunliste = [listeFiyatý]
from [dbo].[ITEMS] order by NEWID()

set @fiyat = ROUND(@urunliste * @urunAdet, 2)
set @kdvfiyat = ROUND(@fiyat * @urunkdv, 2)

INSERT INTO [dbo].[ORDERS_DETAIL]
           ([faturaKod]
           ,[urunKod]
           ,[fiyat]
           ,[KDV]
           ,[adet])
     VALUES
           (@faturaKod
           ,@urunKod
           ,@fiyat
           ,@kdvfiyat
           ,@urunAdet)

set @toplam = ROUND(@toplam + @fiyat + @kdvfiyat, 2)
set @siparisUrunAdet = @siparisUrunAdet - 1

end

update [dbo].[ORDERS] set toplam = @toplam where faturaKod = @faturaKod

fetch next from cls into @faturakod
end

close cls
deallocate cls

