
/* --En fazla satis yapilmis musteri kategorisini bulan fonksiyon. (insurance) */
create or replace function maxsignoffer_viacat
return number
is
    categoryinfo number :=0;
begin
    select categoryinfo into categoryinfo
    from (
            select row_number() OVER(ORDER BY count(so.id) DESC ) SIRA,
            c.client_category_id categoryinfo, count(so.id)
            from insurance.signed_offer so
                inner join insurance.client c on so.client_id=c.id
            group by c.client_category_id
          )
    where SIRA=1;
    return categoryinfo ;
end;

select * from insurance.client_category where id= maxsignoffer_viacat;

/* --2014ten sonra ise giren calisanlarin toplam sayisini veren fonksiyon.(insurance) */
create or replace function totemp (basdate in varchar2)
return number
is
    totemp number :=0;
begin
    select count(employee_id) into totemp
    from insurance.has_role
    where to_char(start_date,'YYYY') > basdate;
    return totemp;
end;

select totemp('2014') from dual;

/* --istenilen kategoride yer alan ürünlerden en son alan kisiyi getiren fonksiyon. (telco) */
create or replace function latestcustomer (marketgroup varchar2)
return varchar2
is
    custnum varchar2(50 Byte) :='';
begin
    select c.customer_num into custnum from telco. subscription s
        inner join telco.subs_lifecycle sl on s.id=sl.subscription_id
        inner join telco.customer c on sl.customer_id=c.id
    where s.activation_date in (
                select max(s.activation_date)
                from telco.offer o
                    inner join telco.subs_lifecycle sl on o.id = s1.offer_id
                    inner join telco.subscription s on sl.subscription_id=s.id
                where o.marketing_group = 'VDSL'
          );
    return custnum;
end;

select * from telco.customer where customer_num = latestcustomer('VDSL');

                                /* PROCEDURES */

create or replace procedure customer_contact
(
p_customer_id number
)
is r_contact contacts%rowtype;
begin
select * into r_contact from contacts
where customer_id=p_customer_id;
dbms_output.put_line(r_contact.first_name||' '||r_contact.last_name||'<'||r_contact.email||'>');
exception
WHEN others then
dbms_output.put_line(SQLERRM);
end;

BEgin
customer_contact(208);
end;


create or replace procedure max_unit_price
is
v_max_unit_price number:=0;
begin
select max(unit_price) into v_max_unit_price from order_items;
dbms_output.put_line('En yüksek birim fiyatı: ' ||v_max_unit_price);
end
;
