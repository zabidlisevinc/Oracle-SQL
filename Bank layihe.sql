--1. Son 3 ayda ümumilikdə ən çox əməliyyat edən müştəri (Musteri adi) və bu müştərinin əməliyyatlarının ümumi məbləğini göstərən sorğu yazın.   
    select c.customer_id,
           count(*) transaction_count,
           sum(t.amount) sum_amount
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and t.transaction_date>=add_months(sysdate,-3)
        group by(c.customer_id)
        order by count(*) desc
        fetch first 1 row only
--2. Hər müştəri üçün son 1 ildə kart hesabından edilən çıxarışların sayını və bu çıxarışların ümumi məbləğini göstərin.
    select c.customer_id,
           count(t.transaction_id),
           sum(t.amount)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and c.changed_date>=add_months(sysdate,-12)
        group by c.customer_id
        
--3. Hər müştəri üçün son 6 ay ərzində edilən əməliyyatların sayına görə, ən çox əməliyyat edən hesab növünü müəyyən edin.
    select c.customer_id,
           count(t.transaction_id) t_count,
           a.account_type
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and t.transaction_date>=add_months(sysdate,-6)
        group by c.customer_id,a.account_type
--4. Müştərilərin son 1 ildə yalnız depozit hesabları ilə bağlı etdikləri əməliyyatların ümumi məbləğini təhlil edin.
    select c.customer_id,
           sum(t.amount)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and a.account_type='Deposit Account'
        and t.transaction_date>=add_months(sysdate,-12)
        group by c.customer_id
        
--5. Hər müştəri üçün son 3 ayda, ən çox kart əməliyyatlarını həyata keçirən tarixləri göstərin.     
    select c.customer_id,
           t.transaction_date,
           count(*)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and t.transaction_date>=add_months(sysdate,-3)
        and t.transaction_type='Card Account'
        group by c.customer_id,t.transaction_date
        order by count(*) desc
--6. Aktiv depoziti olan müştərilərin depozit və kredit məlumatlarının siyahısını çıxarmaq:
    select * 
        from customers c
        inner join deposits d
        on c.customer_id=d.customer_id
        inner join loans l
        on c.customer_id=l.customer_id
        and c.status='ACTIVE'
        
--7. Hər müştəri üçün son 1 il ərzində hər ay üzrə ümumi balans və depozit məbləğini göstərmək üçün sorğu yazın:
    select c.customer_id, 
           to_char(t.transaction_date,'YYYY-MM') months,
           sum(a.balance),
           sum(d.deposit_amount)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        left join deposits d
        on c.customer_id=d.customer_id
        and t.transaction_date>=add_months(sysdate,-12)
        group by c.customer_id,to_char(t.transaction_date,'YYYY-MM')
        order by c.customer_id,months
--8. Son 6 ayda ən yüksək kredit məbləğinə sahib olan müştəri haqqında məlumatlar və kredit məbləğini göstərmək.
    select c.*,
           l.loan_amount
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join loans l
        on c.customer_id=l.customer_id
        and l.start_date>=add_months(sysdate,-6)
        order by l.loan_amount desc
--9. Hər müştərinin son 6 ay ərzində etdiyi ən yüksək məbləğli əməliyyatla bağlı məlumatları (əməliyyat növü, tarix, balans) göstərin.
    select c.customer_id,
           t.transaction_type,
           t.transaction_date,
           t.amount
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and t.transaction_date>=add_months(sysdate,-6)
        group by c.customer_id,t.transaction_type,t.transaction_date,t.amount
        order by t.amount desc
--10. Müştəri ən çox hansı növ kreditlərə müraciət edir və bu kreditlərin növü ilə müştəriyə təklif olunan ortalama faiz dərəcəsi nə qədər təşkil edir?  
    select l.loan_type,
           count(*),
           avg(l.interest_rate) avg_rate
        from customers c
        inner join loans l
        on c.customer_id=l.customer_id
        group by l.loan_type
        order by count(*) desc
--11. Hər müştərinin son 1 ildə açdığı bütün hesabları və bu hesablara görə edilən əməliyyatların ümumi məbləğini göstərmək:
    select c.customer_id,
           a.account_type,
           sum(t.amount) sum_amount
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        and a.date_opened>add_months(sysdate,-12)
        group by c.customer_id,a.account_type
        
--12. Hər müştəri üçün son 1 ildə hər ay üzrə ümumi balans və depozit məbləğini göstərən sorğu:
    select c.customer_id, 
           to_char(t.transaction_date,'YYYY-MM') months,
           sum(a.balance),
           sum(d.deposit_amount)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        left join deposits d
        on c.customer_id=d.customer_id
        and t.transaction_date>=add_months(sysdate,-12)
        group by c.customer_id,to_char(t.transaction_date,'YYYY-MM')
        order by c.customer_id,months
    
--13. Hər bir müştəri üçün son 1 ildə ən yüksək depozit məbləği ilə saxlanılan hesab növünü və bu hesabın açılış tarixini tapın.
    select c.customer_id,
           d.deposit_type,
           
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join deposits d
        on c.customer_id=d.customer_id 
--14. Hər müştərinin son 3 ayda kartlar ilə edilən əməliyyatların sayına görə ən aktiv kart növünü müəyyən edin.
    select c.customer_id,
           k.card_type,
           count(t.transaction_type)
        from customers c
        inner join accounts a
        on c.customer_id=a.customer_id
        inner join transactions t
        on a.account_id=t.account_id
        inner join cards k
        on c.customer_id=k.customer_id
        and t.transaction_date>add_months(sysdate,-3)
        and t.transaction_type='Card Account'
        group by c.customer_id,k.card_type
--15. Müştəri statusu aktiv olanların içərisində Müddət bölgüsü üzrə ümumi kredit məbləğlərini hesablayın.
(Müddət bölgüsü dedikdə kreditin verilmə müddəti nəzərdə tutulur (start_date və end_date). Müddət bölgü aşağıdakı kimi olmalıdır.
0-12 ay
13-24 ay
25-48 ay
48 ay+)
    select c.customer_id,
           c.status,
           case when months_between(l.end_date,l.start_date)<=12 then '0-12 ay'
                when months_between(l.end_date,l.start_date)<=24 then '13-24 ay'
                when months_between(l.end_date,l.start_date)<=48 then '25-48 ay'
                else '48 ay+' 
                end muddet_bolgusu,
           sum(l.loan_amount) umumi_kredit
        from customers c
        inner join loans l
        on c.customer_id=l.customer_id
        where c.status='ACTIVE'
        group by case when months_between(l.end_date,l.start_date)<=12 then '0-12 ay'
                when months_between(l.end_date,l.start_date)<=24 then '13-24 ay'
                when months_between(l.end_date,l.start_date)<=48 then '25-48 ay'
                else '48 ay+' 
                end ,c.customer_id,c.status