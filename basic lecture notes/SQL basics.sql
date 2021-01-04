/* ############################# */
/* ######## INNER JOIN ######### */
/* ############################# */

SELECT * FROM TELCO.ADDRESS ;
SELECT * FROM TELCO.AGREEMENT ;
SELECT * FROM TELCO.ORDERING ;

-- Girilen orderlarin hangi sözlesmeler ile geldigi bilgisini bulalim.
SELECT * FROM TELCO.ORDERING ordering
INNER JOIN TELCO.AGREEMENT agreement ON ordering.agreement_id = agreement.id;

SELECT * FROM TELCO.ORDERING ordering, TELCO.AGREEMENT agreement
WHERE 1 = 1 
AND ordering.agreement_id = agreement.id;

-- Idsi 228 olan ürüne ait bilgileri ve kategori ismini bulunuz.
-- 1. syntax
select p.*, pc.category_name
from sales.products p,
	 sales.product_categories pc  
where 1=1
	 and p.category_id = pc.category_id  --join clause
	 and product_id=228; -- filter
	 
-- 2. syntax
select p.*, pc.category_name
from sales.products p 
	inner join sales.product_categories pc on p.category_id = pc.category_id 
where product_id=228;

-- Ürün satin almis müsterilerin isim, abonelik id ve ürün adi bilgilerini bulunuz.
select cus.name, lfc.subscription_id, prd.product_name
from telco.customer cus
	inner join telco.subs_lifecycle lfc on cus.id=lfc.customer_id
	inner join telco.product prd on lfc.product_id=prd.id
order by cus.name;

SELECT * FROM TELCO.SUBS_LIFECYCLE;

--Hangi bölgeye kayitli kaç hesap vardir?
select region,count(*) 
from banking.accounts acc
	inner join banking.districts dis on acc.district_id=dis.district_id
group by region;

/* ############################# */
/* ######### LEFT JOIN ######### */
/* ############################# */

-- Yapilan sözlesmelerin hangi adreslere yapildigini bulalim.
select * from TELCO.ADDRESS;
select * from TELCO.AGREEMENT;

select count(*) from TELCO.ADDRESS;
select count(*) from TELCO.AGREEMENT;

-- Syntax 1.
SELECT * FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id; 

-- Syntax 2.
SELECT * FROM TELCO.AGREEMENT agreement, TELCO.ADDRESS address
WHERE  1 = 1
AND agreement.id = address.agreement_id (+);

SELECT agreement.id, count(*) FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id
group by agreement.id having count (*) > 1; -- Çoklayan kayitlari bulalim

SELECT * FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id
WHERE agreement.id = 300003; -- Hem servis hem de kontak adres olarak ayriliyor. 

--LEFT JOIN ile filtre kullanim örnegi
SELECT * FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id
WHERE address.addr_type = 'SERVICE_ADDRESS';  -- filtre where e yazildiginda left join kullanmanin anlami kalmadi. inner joine dondu.

SELECT * FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id AND address.addr_type = 'SERVICE_ADDRESS';  -- filtreyi join expressionina ekleyerek left joini koruduk.

SELECT distinct address.addr_type FROM TELCO.AGREEMENT agreement 
LEFT JOIN TELCO.ADDRESS address on agreement.id = address.agreement_id; -- Sadece 2 tip adres var dogrulad?k

/* ############################# */
/* ##  LEFT JOIN - INNER JOIN ## */
/* ############################# */

-- Sozlesme turu 'AGR' olan ve taahhut baslangic tarihi '01/01/2010' dan itibaren olan sözlesmelerin  hangi kayitlari için address bilgileri gelmemektedir?
SELECT * FROM TELCO.SUBS_LIFECYCLE sl
INNER JOIN TELCO.AGREEMENT agreement on sl.agreement_id = agreement.id 
LEFT JOIN TELCO.ADDRESS address      on agreement.id    = address.agreement_id
WHERE 1 = 1
AND agreement.ag_type = 'AGR' 
AND agreement.COMMITMENT_START_DATE > '01/01/2010' 
AND address.id IS NULL;

/* ############################# */
/* ######## RIGHT JOIN ######### */
/* ############################# */

SELECT * FROM TELCO.ADDRESS address 
RIGHT JOIN TELCO.AGREEMENT agreement on agreement.id = address.agreement_id;

-- Bir diger syntax
SELECT * FROM TELCO.ADDRESS address, TELCO.AGREEMENT agreement 
WHERE 1 = 1
AND address.agreement_id (+) = agreement.id;

-- Subscription'u olmayan mü?terileri bulmak istiyorum.
select cus.name, lfc.subscription_id
from telco.subs_lifecycle lfc
	right join telco.customer cus on lfc.customer_id=cus.id
order by cus.name;

/* ############################# */
/* ######## OUTER JOIN ######### */
/* ############################# */

SELECT * FROM SALES.ORDERS orders
FULL OUTER JOIN SALES.EMPLOYEES employees on orders.salesman_id = employees.employee_id 
order by orders.salesman_id, employees.employee_id; -- ne var ne yok çakıştırarak getiriyor. toplamda 3 bilgi var. hiç satış yapmayanlar, satış yapanlar,  satışı olup eksik bilgisi olanları da görebiliyoruz.

/* ############################# */
/* ######## CROSS JOIN ######### */
/* ############################# */

-- Tan?ml? bölgeler ile depolarin kombinasyonlarini bulunuz.
select rgs.region_name, whs.warehouse_name
from sales.warehouses whs
	cross join sales.regions rgs
order by rgs.region_name , whs.warehouse_name;

-- Cartesian çarpim. Data üretmede kullan?labilir.
SELECT * FROM TELCO.AGREEMENT agreement 
CROSS JOIN TELCO.ADDRESS address; 

SELECT * FROM TELCO.AGREEMENT agreement , TELCO.ADDRESS address;

--Derste konustugumuz iphone ornegi.

-- MODEL   -> 11, 12 ,12 MAX, 12 MAX PRO
-- HAFIZA  -> 64 GB, 128 GB , 256 GB
-- RENK    -> Siyah, beyaz, k?rm?z?, mavi

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------Joining Data Practice:-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                                    
--sirkete basladiklarindan beri terfi alip unvan degistiren çalisanlarin bilgilerini bulunuz ve 'PROMOTED' tagi ile etiketleyiniz.
select emp.* , 'PROMOTED'
from insurance.employee emp
	inner join (select employee_id,count(role_id) from insurance.has_role group by employee_id having count(role_id)>1) prm on emp.id=prm.employee_id;

--Sigorta sirketin çalisan kisilerin güncel unvan bilgilerini bulunuz.
select emp.first_name,emp.last_name,rol.role_name
from insurance.employee emp
	inner join insurance.has_role hr on emp.id=hr.employee_id
	inner join insurance.role rol on hr.role_id=rol.id
where hr.end_date is null;

--Ürün kategorisi bazinda verilen bir siparisteki toplam ürün miktari ile toplam tutari bulunuz.
select pca.category_name KATEGORI,sum(oi.quantity) ADET,sum(prd.standard_cost) TUTAR
from sales.order_items oi
	inner join sales.products prd on oi.product_id=prd.product_id
	inner join sales.product_categories pca on prd.category_id=pca.category_id
group by pca.category_name;

--sirketin sundugu tüm tekliflere ait fiyat bilgisi ile müsteri tarafindan alinanlarin satis fiyat bilgisini bulunuz. Kolon olarak müsteri tarafindan satin alinan-alinmayan teklifler için Satilan/Satilmayan notu ekleyiniz.
select ofr.id,ofr.paymemt_amount, sofr.id,sofr.payment_amount, case when sofr.id is null then 'SATILMAYAN' else 'SATILAN' end NOTE
from insurance.offer ofr 
	left join insurance.signed_offer sofr on ofr.id=sofr.offer_id
order by ofr.id;

--Sistemde tanimlanmis adresler/lokasyonlar içerisinde mevcut olmayan ülkeleri ve bulunduklari bölgeyi bulunuz.
select cnt.country_id,cnt.country_name,rg.region_name
from sales.countries cnt
	left join sales.locations loc on cnt.country_id=loc.country_id
	inner join sales.regions rg on cnt.region_id=rg.region_id
where loc.location_id is null
order by rg.region_name;

--Hangi ödeme sebebiyle kaç adet ödeme gerçeklestirildigini bulunuz.
select ptr.reason_name,count(pt.id)
from insurance.payout pt 
	full outer join insurance.payout_reason ptr on pt.payout_reason_id=ptr.id
group by ptr.reason_name
order by ptr.reason_name;

--Tanimli ürünler ile ürün kategorilerine ait kombinasyonlari bulunuz.
select prd.product_name, cat.category_name
from insurance.product prd
	cross join insurance.product_category cat
order by prd.product_name, cat.category_name;

--Toplam hesap sayisi 100den fazla olan bölge-statelerde kaçar hesap vardir?
select region,state_name,count(*) 
from banking.accounts acc
	inner join banking.districts dis on acc.district_id=dis.district_id
group by region,state_name
HAVING COUNT(*) > 100
order by 3 desc;

-- REGION ve STATE bazli toplam hesap sayilarini bulup, toplam hesap sayisi azalacak sekilde siralayiniz.
select region,state_name,count(*) 
from banking.accounts acc
	inner join banking.districts dis on acc.district_id=dis.district_id
group by region,state_name
order by 3 desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* ############################# */
/* #### UNION - UNION ALL ###### */
/* ############################# */

--Contact ve Employee tablolarinda yer alan soyadlarini hem tekil gelecek sekilde hem de tekrarlayan kayit varsa tekrarli gelecek sekilde bulunuz. (Union - Union All farkini görebilmemiz adina basic bir örnek.)
--UNION
select last_name 
from sales.employees 
UNION 
select last_name 
from sales.contacts 
order by last_name; 

--UNION ALL
select last_name 
from sales.employees 
UNION ALL 
select last_name 
from sales.contacts 
order by last_name; 

--Hesabi aktif olan müsteriler ile deaktif müsterilerin hesap numarasi, müsteri ismi ve segment bilgilerini CONN ve DCONN statüleriyle etiketleyiniz.
select ac.account_number NUM, cus.name, cus.segment, 'CONN' GLOB_STAT 
from telco.account ac
	inner join telco.subs_lifecycle lf on ac.id=lf.account_id
	inner join telco.customer cus on lf.customer_id=cus.id
where ac.status='ACTIVE'
UNION
select ac.account_number NUM, cus.name, cus.segment, 'DCONN' GLOB_STAT
from telco.account ac
	inner join telco.subs_lifecycle lf on ac.id=lf.account_id
	inner join telco.customer cus on lf.customer_id=cus.id
where ac.status='DEACTIVE';

/* ############################# */
/* ########### MINUS ########### */
/* ############################# */

--Mü?terilerden güncel contact bilgisi olmayanlari bulunuz. -- Bu ornegi Intersectteki örnekle beraber incelemenizi oneririz
select customer_id from telco.contact where status <> 'USED'
MINUS
select customer_id from telco.contact where status <> 'UNUSED';

--Sistemde adresi kayitli olmayan müsteri bilgilerini bulunuz.
select * 
from telco.customer
MINUS
select distinct cus.* 
from telco.address adr
	inner join telco.agreement agr on adr.agreement_id=agr.id
	inner join telco.subs_lifecycle lf on agr.id=lf.agreement_id
	inner join telco.customer cus on lf.customer_id=cus.id;


--Sadece aylik ve yillik ödeme seçenegi olan poliçelerden kaçinin satildigini kaçinin satilmadigini 'SOLD' 'UNSOLD' durumuyla etiketleyiniz.
select POLICY_ID , 'UNSOLD' SALES_STATU
from (
		select pt.id POLICY_ID from insurance.policy_type pt where pt.monthly_payment=1 and pt.yearly_payment=1 and pt.quarterly_payment=0
        MINUS
		select distinct policy_type_id from insurance.signed_offer
	)
UNION
select pt.id POLICY_ID,'SOLD' SALES_STATU 
from insurance.policy_type pt
    inner join insurance.signed_offer so on pt.id=so.policy_type_id
where pt.monthly_payment=1 and pt.yearly_payment=1 and pt.quarterly_payment=0;

/* ############################# */
/* ######### INTERSECT ######### */
/* ############################# */

--Müsterilerden contact bilgisi degismis ve yenisi girilmis bulunuz. -- Bu ornek MINUStaki örnekle iliskilidir.
select customer_id from telco.contact where status <> 'USED'
INTERSECT
select customer_id from telco.contact where status <> 'UNUSED';

--Satis yapmis çalisanlarin bilgilerini bulunuz.
select *
from sales.employees
where employee_id in (
    select salesman_id from sales.orders
        INTERSECT
    select employee_id from sales.employees
	);

--Sistemde adresi kayitli olan müsteri bilgilerini bulunuz.
select *
from telco.customer
INTERSECT
select distinct cus.*
from telco.address adr
	inner join telco.agreement agr on adr.agreement_id=agr.id
	inner join telco.subs_lifecycle lf on agr.id=lf.agreement_id
	inner join telco.customer cus on lf.customer_id=cus.id;
    
--Contact ve Employee tablolarinda yer alan ayni soyadlari bulunuz.
select last_name 
from sales.employees 
INTERSECT
select last_name 
from sales.contacts 
order by last_name; 

--Satis yapmis çalisanlarin bilgilerini bulunuz.
select *
from sales.employees
where employee_id in (
    select salesman_id from sales.orders
        INTERSECT
    select employee_id from sales.employees
	);
    
/* ############################# */
/* ########### CONCAT ########## */
/* ############################# */

select concat ('Kodluyoruz','-SQL Bootcamp') from dual;

select concat(concat (ord.order_code,'+'), agr.ag_num)
from telco.ordering ord
	inner join telco.agreement agr on ord.order_number=agr.order_num
	inner join telco.subs_lifecycle sl on agr.id=sl.agreement_id
	inner join telco.product pr on sl.product_id=pr.id;
    
select ord.order_code || '+' ||  agr.ag_num
from telco.ordering ord
	inner join telco.agreement agr on ord.order_number=agr.order_num
	inner join telco.subs_lifecycle sl on agr.id=sl.agreement_id
	inner join telco.product pr on sl.product_id=pr.id;

/* ############################# */
/* ########### LENGTH ########## */
/* ############################# */

select length ('Kodluyoruz') from dual;

-- Kimlik numarasinin uzunlugu 11'den farkli olan müsteri bilgilerini bulunuz.
select * from telco.customer where length(NATIONALITY_NUMBER) <>11;

/* ############################# */
/* ########### SUBSTR ########## */
/* ############################# */
select substr ('Kodluyoruz',0,3) from dual;
select substr ('Kodluyoruz',3,6) from dual;

-- Teklif açiklamalarini bastan baslayarak 5 karakter uzunlugunda olacak sekilde düzenleyiniz.
select substr(description,0,5) from telco.offer;

/* ############################# */
/* ########### INSTR ########### */
/* ############################# */

--Returns the location of a substring in a string.
select instr ('Kodluyoruz','o') sonuc from dual; -- Output:2 (the first occurrence of 'o')
select instr ('Kodluyoruz','o',1,1) sonuc from dual; -- Output:2 (the first occurrence of 'o')
select instr ('Kodluyoruz','o',1,2) sonuc from dual; -- Output:7 (the second occurrence of 'o')

-- Icinde A.S gecen sirketleri bulalim
select * from telco.customer where instr(name,'A.S.') <>0;

/* ############################# */
/* ############ LPAD ########### */
/* ############################# */

-- Contact tipi 'PHONE' olan kayitlarin degerlerini 0 ile 12 haneye tamamlayaniz. (Soldan tamamlama ile)
select id, cnt_type, lpad(cnt_value,12,'0') as PHONE_NUMBER from telco.contact where cnt_type='PHONE';

/* ############################# */
/* ############ RPAD ########### */
/* ############################# */

-- Posta kodlarini '-' ile 7 karaktere tamamlayiniz. (Sagdan tamamlama ile)
select id,rpad(postal_code,7,'-' ) as POSTAL_CODE, full_address from telco.address;

/* ############################# */
/* ############ TRIM ########### */
/* ############################# */

select trim(leading '0' from '002740028744000')from dual; -- bastan karakter siliyor
select trim(trailing '0' from '002740028744000') from dual; --sondan karakter siliyor
select trim(both '0' from '002740028744000') from dual; --hem bastan hem sondan karakter siliyor

-- 
select order_code, trim('C' from order_code) from telco.ordering;

--
select commitment_start_date,trim(leading '0' from commitment_start_date) from telco.agreement;

/* ############################# */
/* ########### REPLACE ######### */
/* ############################# */

select replace ('Kodluyoruz','ruz') from dual;
select replace ('SQLBootcampSQL','SQL') from dual; 
select replace ('SQLBootcamp','SQL','Kodluyoruz ') from dual; -- ifadeyi gördügü yere ikinci ifadeyi getiriyor.

--
select quota,replace(quota,'GB') from telco.product;

--
select speed,replace(speed, 'Mbps') from telco.product;

/* ############################# */
/* # UPPER || LOWER || INITCAP # */
/* ############################# */
select upper ('Kodluyoruz') from dual;
select lower ('KODLUYORUZ') from dual;
select initcap ('KODLUYORUZ BOOTCAMP') from dual;

-- Hesap adlarini büyük harf gelecek sekilde düzenleyiniz.
select upper(account_name) from telco.account;

--
select initcap(agr.status) || ' statülü ' || agr.ag_num || ' numarali sözlesmeye ait ' || lower(adr.addr_type) || ' : ' || upper(adr.full_address) from telco.address adr
	inner join telco.subs_lifecycle lf on adr.agreement_id=lf.agreement_id
	inner join telco.agreement agr on lf.agreement_id=agr.id;

/* ############################# */
/* ###### ROUND - TRUNC ######## */
/* ############################# */
select round (10.315) from dual;
select round (10.315,2) from dual;

select trunc (10.315) from dual;
select trunc (10.315,2) from dual;

--
select list_price,
	round(list_price) sale_price,
	trunc(list_price) discount_price, 
	1000*(round(list_price) - list_price) AS profit, 
	1000*(list_price - trunc(list_price)) loss 
from telco.offer
order by 4 desc;

-- Kredilerin çekilme amaçlarina göre gruplarindaki en yüksek tutara oranlari nelerdir?
select loan_id,amount,purpose,max_purpose_loan_amount,round((amount/max_purpose_loan_amount)*100,2) as per_of_max_amount 
from (
	select l.*,max(amount) over(partition by purpose) as max_purpose_loan_amount 
	from banking.loans l
	)
order by 3,2 desc;

-- Kredilerin çekilme sürelerine göre gruplarindaki en yüksek tutara oranlari nelerdir?
select loan_id,amount,duration,max_duration_loan_amount,round((amount/max_duration_loan_amount)*100,2) as per_of_max_amount 
from (
	select l.*,max(amount) over(partition by duration) as max_duration_loan_amount 
	from banking.loans l
	)
order by 3,2 desc;

-- Satilan offerlarin ortalama kaç ay sonra satildigini bulunuz.
select ofr.id OFFER_ID, ofr.date_offered TEKLIF_TARIHI , avg(ayfarki.AY)
from insurance.offer ofr
    inner join insurance.signed_offer so on ofr.id = so.offer_id
    inner join (
                select ofr.id, round(months_between (so.date_signed, ofr.date_offered)) AY
                from insurance.offer ofr
                    inner join insurance.signed_offer so on ofr.id = so.offer_id
                ) ayfarki on ofr.id=ayfarki.id
group by ofr.id, ofr.date_offered 
order by ofr.id;

/* ############################# */
/* ############ MOD ############ */
/* ############################# */

SELECT mod(37,4)FROM DUAL;

/* ############################# */
/* ######### TO_CHAR ########### */
/* ############################# */

-- 2015 ve 2017 yillarinda verilen siparislerden Pending statusünde olan var mi?
select * from sales.ORDERS where to_char(order_date,'yyyy') in (2015,2017) and status='Pending';

-- ise alim tarihi Ocak 2016 olan çalisanlari bulunuz.
select * from sales.employees where to_char(hire_date, 'YYYYMM') = '201601';


/* ############################# */
/* ###  TO_DATE - TO_NUMBER  ### */
/* ############################# */

-- Kotasi 100 GB den küçük olan urunleri bulunuz.
select * from (
    select product_name, total_amount, QUOTA,'GB', to_number(trim(replace(QUOTA,'GB'))) QUOTA_NUM
    from telco.product
    where quota not in ('NONE','LIMITLESS') 
) where QUOTA_NUM <100;

-- ise alim tarihi > Ocak 2016 olan çalisanlari bulunuz.
select * from sales.employees where hire_date > to_date ('2016','YYYY') ;

-- Satin alinan tekliflerden imza tarihleri 2005 ile 2011 arasinda olanlarin satis gerceklestiren satici bilgisi ve ürün ismini getiriniz
select ofr.date_signed, ofr.is_active, p.product_name, emp.first_name
from insurance.signed_offer ofr
    inner join insurance.product p on ofr.product_id=p.id
    inner join insurance.has_role hr on ofr.has_role_id=hr.id
    inner join insurance.employee emp on hr.employee_id=emp.id
where ofr.date_signed between to_date('2005','YYYY') and to_date('2011','YYYY')
order by ofr.date_signed;

/* ############################# */
/* ######### ADD_MONTHS ######## */
/* ############################# */

select * from telco.offer;

SELECT offer_closing_date, ADD_MONTHS(offer_closing_date,2) NEW_CLOSING_DATE
FROM  telco.offer where offer_closing_date is not null;

/* ############################# */
/* #### NEXT_DAY || LAST_DAY ### */
/* ############################# */

select to_char(sysdate, 'Month') from dual;
select to_char(sysdate, 'Day') from dual;

-- Tanimli aktivasyon tarihinden sonraki ilk Pazaretsi gününü getirmek istiyoruz.
select 
ID, 
ACTIVATION_DATE,  
NEXT_DAY(ACTIVATION_DATE, 'MONDAY') F_DATE, 
TO_CHAR(NEXT_DAY(ACTIVATION_DATE, 'MONDAY'),'Day') DAY_DATE 
from TELCO.subscription ;

-- Pazar günü aktive olan abonelikleri bulalim.
select * from TELCO.subscription where TO_CHAR(ACTIVATION_DATE, 'Day') = 'Sunday'; -- kayit gelmeme sebebi nedir?

select 
TO_CHAR(ACTIVATION_DATE, 'Day')  DAY_DATE,  -- aslinda dönen deger 9 karaktere tamamlanacak sekilde bosluk iceriyor. Bu sebeple 'Sunday' filtresine cevap vermedi.
LENGTH(TO_CHAR(ACTIVATION_DATE, 'Day')) DAY_LENGTH 
from TELCO.subscription; 

-- Bosluklu geldigini gördukten sonra verdigimiz filtreyi degistirebiliriz.
select * from TELCO.subscription where TO_CHAR(ACTIVATION_DATE, 'Day') like 'Sunday%';

-- Ya da dönen degerden, trim fonksiyonunu kullanarak bosluklari sileriz.
select * from TELCO.subscription where TRIM(TO_CHAR(ACTIVATION_DATE, 'Day')) = 'Sunday';

---
select subs.*, LAST_DAY(subs.deactivation_date) EOD from TELCO.subscription  subs where subs.deactivation_date is not null;


/* ############################# */
/* #### FIRST || LAST VALUE  ### */
/* ############################# */

select * from insurance.offer;

--
select id,payment_amount,product_id,
       first_value (payment_amount) over (partition by product_id order by id) as FV
from insurance.offer
order by product_id;

SELECT id, payment_amount, product_id, 
    first_value(payment_amount) OVER (partition by product_id order by id desc) as lv  
FROM insurance.offer order by product_id;

SELECT id, payment_amount, product_id, 
    last_value(payment_amount IGNORE NULLS) OVER (PARTITION BY product_id ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as lv  
FROM insurance.offer order by product_id;


SELECT id, payment_amount, product_id, 
    last_value(payment_amount IGNORE NULLS) OVER (PARTITION BY product_id ORDER BY ID DESC ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as lv  
FROM insurance.offer order by product_id;

/* ############################# */
/* # ROUND - TRUNC (FOR DATES) # */
/* ############################# */

--Q >> Rounds up on the 16th day of the second month of the quarter.
--W >> Same day of the week as the first day of the month

select sysdate, round(sysdate,'Q') from dual; 
select sysdate, round(sysdate,'W') from dual;

--
select '10.08.2020', trunc(to_date('10.08.2020'),'Q') from dual; 
select '10.08.2020', trunc(to_date('10.08.2020'),'MONTH') from dual; 

/* ############################# */
/* ######## EXTRACT ############ */
/* ############################# */

select extract(day from sysdate) from dual;
select extract(month from sysdate) from dual;
select extract(year from sysdate) from dual;

--
select to_date((extract(day from sysdate)|| extract(month from sysdate)|| extract(year from sysdate)), 'DDMMYYYY') from dual;

--  Teklif tarihi 2010 büyük olan offerlarin durumunu (aktif / pasif olarak), poliçe tipini, açiklamasini ve toplam satis adedini bulalim
select 
    decode(ofr.is_active,1,'Aktif',0,'Pasif') TEKLIF_DURUMU,
    pt.type_name POLICE_TIPI,
    pt.description POLICE_ACIKLAMA,
    count (so.id) SATILAN_TOTAL_TEKLIF
from insurance.offer ofr
    inner join insurance.policy_type pt on ofr.policy_type_id=pt.id
    left join signed_offer so on pt.id=so.policy_type_id
where extract(year from ofr.date_offered) > 2010
group by ofr.is_active,
    pt.type_name,
    pt.description;

/* ############################## */
/* NVL - NVL2 - NULLIF - COALESCE */
/* ############################## */

-- NVL      : Converts null value to an actual value.
--          NVL(exp1, exp2)
-- NVL2     : If first expression is not null, return second expression. If first expression is null, return third expression. the first expression can have any data type.
--          NVL2(exp1, exp2, exp3)
-- COALESCE : Return first not null expression in the expression list.
--          COALESCE(exp1, exp2, expr3, ...)
-- NULLIF   : Compares two expressions and returns null if they are equal,returns the first expression if they are not equal. exp1 cannot be NULL.
--          NULLIF(exp1, exp2)

SELECT NVL(null, 'Kodluyoruz') FROM dual;
SELECT NVL('Bootcamp', 'Kodluyoruz') FROM dual;

SELECT NVL2 (null, 'Kodluyoruz','SQL') FROM dual;
SELECT NVL2 ('Bootcamp', 'Kodluyoruz','SQL') FROM dual

SELECT COALESCE ('Bootcamp', 'Kodluyoruz') FROM dual;
SELECT COALESCE (null,'Bootcamp', 'Kodluyoruz') FROM dual;
SELECT COALESCE (null,null, 'Kodluyoruz') FROM dual;

SELECT NULLIF ('Bootcamp', 'Kodluyoruz') FROM dual;
SELECT NULLIF ('Bootcamp', 'Bootcamp') FROM dual;

--
select acc.account_id account, tra.operation, NVL(bank,'UNK') bank, acc.district_id, count(tra.id)
from banking.accounts acc
    left join banking.transactions tra on acc.account_id=tra.account_id
where last_day(to_date(tra.year,'YYYY')) = to_date('11.30.2015','MM.DD.YYYY')
group by acc.account_id, tra.operation, NVL(bank,'UNK'), acc.district_id
order by acc.account_id;

-- Teklif kapama tarihi bos olan tekliflere, açilis tarihlerinden 9 ay sonra kapanacak sekilde kapanis tarihi giriniz.
select 
offer_code,
ofr_type,
offer_opening_date,
NVL(offer_closing_date, add_months(offer_opening_date,9)) offer_end_date
from telco.offer;

-- Teklif kapama tarihi bos olan tekliflere, bugünden sonraki ilk sali gününü atayin.
select 
offer_code,
ofr_type,
offer_opening_date,
NVL(offer_closing_date, next_day(sysdate,'TUESDAY')) offer_end_date
from telco.offer;

--
select offer.*, COALESCE(PROMOTION_PRICE, LIST_PRICE, 5) INVOICE_PRICE from TELCO.offer offer;

/* ############################# */
/* ######## RANK OVER ########## */
/* ############################# */

--
select  
    rank() OVER(PARTITION BY category_id ORDER BY list_price DESC ) rank,  
    category_id,     
    product_name,  
    list_price 
from  sales.products ;

--
select district_id, age, rank() over(partition by district_id order by age desc) "RANK"
from banking.clients
order by district_id,"RANK",age;

/* ############################# */
/* ########## LISTAGG ########## */
/* ############################# */

-- Her departmana ait çalisanlari tek bir satirda virgül koyarak göstermek istiyoruz.
select 
	job_title, 
	LISTAGG(first_name,',') WITHIN GROUP( ORDER BY first_name ) AS employees 
from sales.employees 
group by job_title 
order by job_title;

--Tanimli ürün tiplerini tek alanda gösteriniz.
select listagg(product_type, ', ') within group (order by product_type) "Product Types"
from (select distinct product_type from telco.product);

/* ############################# */
/* ######## ROW NUMBER ######### */
/* ############################# */

--
select  
    row_number() OVER(ORDER BY list_price DESC ) row_num,  
    product_name,  
    list_price 
from sales.products; 

/* ############################# */
/* ######## LEAD - LAG ######### */
/* ############################# */

-- Ürün tanimlamalari yapilirken liste fiyatlari bir önceki teklife yazilmis. Tekliflerin gerçek degerlerini gösteriniz.
select id, list_price WRONG_VALUE, LAG(list_price,1) over (order by id) ACTUAL_VALUE from telco.offer;

-- Ürün tanimlamalari yapilirken liste fiyatlari bir sonraki teklife yazilmis. Tekliflerin gerçek degerlerini gösteriniz.
select id, list_price WRONG_VALUE, LEAD(list_price,1) over (order by id) ACTUAL_VALUE from telco.offer;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Ortalama kredi limitinden yüksek kredi limiti olan müsteriler hangileridir?
select * from sales.customers where credit_limit > (select avg(credit_limit)from sales.customers);

-- Kredi limiti minimum kredi limitinden büyük olan müsterileri bulunuz.
select * from sales.customers where credit_limit > (select min(credit_limit) from sales.customers);

-- Müsterilerin yaslarinin max-min-avg degerlerini getirin.
select max(age) , min (age) , avg (age)
from ( 
      select (to_number(to_char(sysdate,'YYYY')) - to_number(to_char(birthday,'YYYY'))) AGE
      from telco.customer
      where birthday is not null
     );
     
-- Yillar ve aylar bazinda çekilme amaçlarina göre inceleme yapildiginda en düsük kredi tutarlari grafigini gözlemlemek için yazilacak sorgu nedir?
-- Örnek sorgu 1:
select year,month,purpose,min(amount) from banking.loans
group by year,month,purpose
order by 1 desc,2 desc,3 desc;
-- Örnek sorgu 2:
select l.*,min(amount) over(partition by year,month,purpose) from banking.loans l
order by year desc,month desc,purpose asc,amount asc;

-- islemlerin tiplerine göre ortalamalarini AVG fonksiyonunu kullanmadan hesaplayiniz. 
select type,sum(amount) /count(*)
from banking.transactions
group by type

-- islemlerin tiplerine göre ortalamalarini AVG fonksiyonu ile hesaplay?n?z. 
select type,sum(amount) /count(*),avg(amount)
from banking.transactions
group by type;

-- Ürünlerimizin maliyet ücreti ortalama kaçtir?
select avg(standard_cost) from sales.products;

-- Satis islemi gerçeklesmis siparislerin ortalama emir süresi ne kadard?r?
select avg(total_order_duration) from telco.ordering where status = 'COMPLETED';

-- Ürünlerde liste fiyati üzerinden en az kar kaçtir?
select min(list_price - standard_cost) from sales.products ;

-- Hangi farkli kullanim sikliklarinda toplam kaç hesap vardir?
select frequency, count(account_id) from banking.accounts group by frequency;

-- Liste fiyati ortalama liste fiyatina esit ve ya fazla olan productlarin categoryleri nelerdir?
-- Örnek sorgu 1:
select distinct category_id from sales.PRODUCTS where list_price>=(select avg(list_price) from sales.products);
-- Örnek sorgu 2:
select distinct pc.category_name 
from sales.PRODUCTS p
	inner join sales.product_categories pc on p.category_id=pc.category_id
where list_price>=(select avg(list_price) from products);

--
select pr.product_type, sl.relation_status,count(cus.customer_num)
from telco.customer cus
	inner join telco.subs_lifecycle sl on cus.id=sl.CUSTOMER_ID
	inner join telco.product pr on sl.product_id=pr.id
group by pr.product_type, sl.relation_status
order by pr.product_type;
