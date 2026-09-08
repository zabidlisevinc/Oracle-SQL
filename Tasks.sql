1. Departament üzrə üçüncü ən çox əmək haqqı alan və məlumatında hər hansı dəyişiklik edilmiş(job_history) əməkdaşların
ad, soyad, departament nömrəsi(department_id), işlədiyi vəzifə(job_id), əmək haqqı, 
departamentin adı, şəhərin adı, ölkə kodu, ölkə adı haqqında məlumatı ekrana çıxardan sorğunu yazın. 
select e.first_name,
       e.last_name,
       e.department_id,
       e.job_id,
       e.salary,
       d.department_name,
       l.city,
       c.country_id,
       c.country_name
        from employees e
        inner join departments d
        on e.department_id=d.department_id
        inner join locations l
        on d.location_id=l.location_id
        inner join countries c
        on l.country_id=c.country_id
        where (e.salary,e.department_id)in
                              (select e.salary,e.department_id from employees e 
                               group by salary,department_id
                               order by salary desc
                               offset 2 rows
                               fetch first 1 row only)
              and e.employee_id in (select jh.employee_id from job_history jh
                                         group by jh.employee_id
                                         having count(*)>1)

2. Ishciler ishe ayin 1-inden goturulmeye biler. Ele sorgu yazin ki, ishcinin ilk ay nece gun ishlediyini gostersin. 
job_id='SH_CLERK' olsun. 
First_name, last_name, days_worked sutunlari cixarilsin ekrana(məsələn işçi 10-03-2000 işə qəbul olubsa həmin ay üzrə işlədiyi gün: 
22 gün olacaqdır)
    select first_name,
           last_name,
           last_day(hire_date)-hire_date days_worked
           from employees e
           where job_id='SH-CLERK'
           
3. Countries cedvelinden olke adlarinin orta uzunlugunu hesablayan sorgu yazin. Netice en yaxin tam edede qeder 
yuvarlaqlashdirilmalidir.
    select round(avg(length(c.country_name)))
        from countries c
4. Aşağıdakı candidates cədvəlindən istifadə edərək hər vəzifə üçün kümülatif cəm (cumulative sum) məlumatını ekrana çıxardan
sorğunu yazın. 
  
      candidates  
      ID	POSITION	SALARY
      1	         junior	        10500
      2	         senior	        15000
      3	         senior	        35000
      4	         junior	        8000
      5	         senior	        30000
      6	         senior	        25000
      7	         junior	        30000
      8	         senior	        50000
      9	         senior	        30000
     10	         junior	        7000
     11	         junior	        8000
     12	         senior	        33000
     13	         junior	        5000
     14	         senior	        47000
     15	         junior	        12000
-----------------------------------------------------------------------------------
    select position,
           sum(salary) 
           from candidates c
           group by position
5. Manager-i Payam olan butun ishcilerin ad soyad, salary, employee_id-ni gosteren sorgu yazin
    select  e.first_name,
            e.last_name,
            e.salary,
            e.employee_id
            from employees e
            inner join employees m
            on e.manager_id=m.employee_id
            and m.first_name='Payam'
        
6.  Aşağıda ADDRESS və CUST_INF cədvəlləri verilmişdir.  
       
       ADDRESS
       CUST_ID	TYPE_ID	      NAME
         100	   1	  Qeydiyyatda olduğu ünvan
         100	   2	  Faktiki yaşadığı ünvan
         100	   3	  Daimi yaşadığı ünvan
   
       CUST_INF 
       CUST_ID	    FULL_NAME
         100	 Məmmədov Eldar Sabir

     ADDRESS və CUST_INF cədvəllərini join edərək aşağıdakı məlumatları əldə edən sorğunu yazın. 

     CUST_ID	   NAME_QEYDIYYAT	       NAME_FAKTIKI	    NAME_DAIMI
      100	Qeydiyyatda olduğu ünvan  Faktiki yaşadığı ünvan  Daimi yaşadığı ünvan
--------------------------------------------------------------------------------------------------
    select a.cust_id,
           case when a.type_id=1 then NAME_QEYDIYYAT,
           case when a.type_id=2 then NAME_FAKTIKI,
           case when a.type_id=3 then NAME_DAIMI
           from address a
           inner join cust_inf c
           on a.cust_id=c.cust_id
           
7. Student və Record cədvəlləri vasitəsilə qeyd olunan birləşmələrin nəticərini yazın
     
     Student
     id  name  class  city
     3   Hina    3    Delhi
     4   Megha   2    Delhi
     6   Gouri   2    Delhi
      
     Record 
     id class	city
     9	  3	Delhi
     10   2	Delhi
     12   2	Delhi

     1. Inner Join
     name	id	class	city
     Hina    3    3    Delhi
     Megha   4    2    Delhi
     Gouri   6    2    Delhi    
     
     2. Left Join
     name	id	class	city
     Hina    3    3    Delhi
     Megha   4    2    Delhi
     Gouri   6    2    Delhi    
     
     4. Right Join
     name	id	class	city
     null   9     3     Delhi
     null   10    2     Delhi
     null   12    2     Delhi
     
     5. Full outer Join
     name	id	class	city
     Hina    3    3     Delhi
     Megha   4    2     Delhi
     Gouri   6    2     Delhi    
     null    9    3     Delhi
     null   10    2     Delhi
     null   12    2     Delhi


8. Əməkdaşların əmək haqqlarının 20 % -nin üzərinə 500 əlavə etdikdə departamentlər üzrə orta əmək haqqıya bərabər olan
(yuvarlaqlaşdırma tam hissəyə görə olmalıdır) məlumatları təyin edən sorğunu yazın.   
    select * from employees e
    where salary*1.2 +500= (select round(avg(e.salary)) from employees emp
                                where e.department_id=emp.department_id)
                                                                                                                        
      
9. 10.03.2002 və 25.03.2023 -cü il tarix intervallarında həftənin bazar günlərinin düşdüyü tarixi təyin edən sorğunu yazın. 
    with tarix (t) 
    as (select to_date('10-MAR-02','dd-mon-yy')
    from dual 
    union all
    select t+1 from tarix 
    where t<to_date('25-MAR-23','dd-mon-yy'))
    select t from tarix 
    where to_char(t,'fmday')='sunday'
    
10. Tranzaksiya cədvəlindəki məlumatlara əsasən hər sətrin yanında gün ərzində müştərinin etdiyi əməliyyatların sayı və 
gün ərzində etdiyi tranzaksiyalar üzrə məbləğlərin cəmini göstərən sorğunu yazın. 

       Transactions
       Transaction_id   Amount       Dates     Customer_id
        100001          1500      17.02.2023    100005
        100002          600       17.02.2023    100005
        100003          700       17.02.2023    100005
        100004          3500      21.05.2023    100006
        100005          900       21.02.2023    100006
        100006          800       21.02.2023    100006
-----------------------------------------------------------
    select transaction_id,
           count(customer_id),
           sum(amount)
           from transactions
           group by transaction_id,customer_id,dates

11. Departament üzrə ümumi əmək haqqı Employees cədvəlində salary sütunu üzrə özündən 3 əvvəlki özü və özündən 3 sonrakının 
cəminə bərabər olan məlumatları ekrana çıxardan sorğunu yazın. Ekrana departament nömrəsi və umumi cəm haqda məlumatlar çıxsın.
    
12. 80 nomreli departmentde ishleyen ishcilerin employee_id, job_title, nece gun ishlediyini  gosteren sorgu yazin 
(employees, jobs)
    select e.employee_id,
           j.job_title,
           round(sysdate-e.hire_date) gun_sayi
           from employees e
           inner join jobs j
           on e.job_id=j.job_id

13. Dünya Azərbaycanlılarının Həmrəylik Günü cümləsindən hər bir sözü aryıca sütun şəklində ekrana çıxardan sorğu yazın
(dörd sütun olacaq sorğuda).
    select substr( aze,1,instr(aze,' ')-1) as sutun_1,
           substr( aze,instr(aze,' ')+1,instr(aze,' ',1,2)-instr(aze,' ')-1) as sutun_2,
           substr( aze, instr(aze,' ',1,2)+1,instr(aze,' ',1,3)-instr(aze,' ',1,2)) as sutun_3,
           substr( aze,instr(aze,' ',1,3)+1) as sutun_4
           from ( select 'Dünya Azərbaycanlılarının Həmrəylik Günü' aze from dual)

14. 12Oracle18 sözündən əvvəldə olan 12 və sonda olan 18 ədədlərini ekrana çıxardan sorğunu yazın. 
    select substr('12Oracle18',1,instr('12Oracle18','O')-1)||substr('12Oracle18',length('12Oracle18')-1,2) reqem from dual

15. X1 tablesindəki İD  sütununda aşağıdakı məlumatlar var.
id
1
2
3
4
5
Bu cədvəl 5 sətirdən ibarətdir.
Select sum(1) from X1 sorğusunun nəticəsi necə olacaq (Rəqəmi qeyd edin)?
    5 olacaq.Cunki her setirden 1 deyer goturur
    
16.Aşağıdakı Customer adli table verilib. Customer tablesində idsi MAX olan ilk 2 musterinin adini və soyadini ayrı ayrı 
sütunlarda gətirmək( Alias tətbiq etməyi unutmayın)
id	Full_name
1	Pat Fay
2	Steven King
3	Jeniffer Whallen
4	Luis Popp
5	Juliya Nayer

    select substr(full_name,1,instr('full_name',' ')-1) first_name,
           substr(full_name,-1,instr('full_name',' ')+1) last_name
           from customer
           order by id desc
           fetch first 2 rows only