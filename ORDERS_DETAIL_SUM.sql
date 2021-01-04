declare @fKod int
declare @toplam float

declare cls cursor for select faturaKod
from [dbo].[ORDERS] order by kullaniciKod asc
open cls
fetch next from cls into @fKod

while @@FETCH_STATUS = 0
begin

select @toplam = SUM(fiyat) from [dbo].[ORDERS_DETAIL] where faturaKod = @fKod

update [dbo].[ORDERS] set toplam = @toplam where faturaKod = @fKod

fetch next from cls into @fKod
end

close cls
deallocate cls
