select * from ORDERS
select MAX(ADET) from ORDERS_DETAIL

-- alýþveriþ listesi ve kiþiler
SELECT faturaKod, IT.urunKod, fiyat, adet, urunAdý, listeFiyatý, NAMESURNAME, ADDRESS FROM ORDERS_DETAIL ORD
INNER JOIN ITEMS IT ON IT.urunKod = ORD.urunKod
INNER JOIN CUSTOMERS CUS ON CUS.ID = ORD.faturaKod

SELECT faturaKod, SUM(fiyat) FROM ORDERS_DETAIL
GROUP BY faturaKod




SELECT convert(int, rand() * 25 +1)

SELECT RAND() * 25 +1