select * from ORDERS WHERE faturaKod = 50000

--select * from ORDERS_DETAIL

select faturaKod, SUM(fiyat) from ORDERS_DETAIL where faturaKod = 50000 GROUP BY faturaKod 


declare @tarih varchar(50)
declare @tarihInt int 

set @tarih = CAST('2020-02-19' AS varchar)
set @tarih = REPLACE(@tarih, '-', '')
set @tarihInt = CAST(@tarih AS INT)

SELECT cast('2020-02-19 16:19:58.000' as datetime)

declare @timestamps as varchar(100)
set @timestamps = convert(varchar, cast('2020-02-19 16:19:58.000' as datetime), 121)
select @timestamps

set @timestamps = REPLACE(@timestamps, '-', '')
set @timestamps = REPLACE(@timestamps, ':', '')
set @timestamps = REPLACE(@timestamps, ' ', '')
set @timestamps = REPLACE(@timestamps, '.', '')
declare @timestampsInt as bigint
set @timestampsInt = CAST(@timestamps as bigint)
select @timestampsInt

select * from orders order by siparisTarih
