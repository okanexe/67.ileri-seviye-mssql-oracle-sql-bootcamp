## PL-SQL

declare
t number := 0;
begin
loop
t := t + 1;
exit when t < 7;
dbms_output.put_line(t);
end loop;
end;


# for loop
begin
for t in 10..15 loop
dbms_output.put_line(t);
end loop;
end;

# function
create or replace function topla
(
  t1 in pls_integer,
  t2 in pls_integer
)
return pls_integer
is
begin
  return t1 + t2
end;

begin
  dbms_output.put_line(topla(10, 20));
end;


# get full customer name from different column in banking.clients table.

select c.first || ' ' || c.middle || ' ' || c.last as full_name
from banking.clients c;

create or replace function getFullCustName(clientid varchar2)
return varchar2
is
custname varchar2(4000);
begin
select c.first || ' ' || c.middle || ' ' || c.last
into custname
from banking.clients c
where c.client_id = clientid;
return custname
end;

select getFullCustName('C00000100') from dual;

//------------------------------------------------

select account_id, count(*),
row_number() over(order by count(trans_id) desc) as rn
from banking.transactions
where operations = 'Credit in Cash'
group by account_id
;

create or replace function maxTransaction
  (operationtype varchar2)
return varchar2
is
account_id varchar2(50 byte);
begin
select
account_id into account_id
from
(
  select account_id, count(*),
  row_number() over(order by count(trans_id) desc) as rn
  from banking.transactions t
  where t.operations = operationtype
  group by account_id
)
where rn=1;
return account_id;
end;

select maxTransaction('Credit in Cash') from dual;

/* burada row_number verilmesinin nedeni account_id'nin yaptığı transaction sayısına göre
sıralaması yapılıyor yani en çok transcation yapan kişilere göre row_number atanıyor
burda amaç ilerde diyelim en çok transcation yapan 10.kişiye istediğimiz zaman
row_number'ı 10 olan kullanıcıyı döndürmemiz yeterli ve kolay olacaktır. */
