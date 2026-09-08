--1.Maashi her hansi bir department uzre minimal maasha beraber olan ishcilerin name ( first name and last name ),
-- salary, department id cixaran sorgu yazin. 
    select min(salary) from employees e where department_id=e.department_id
  ------------------------------------------------------------------------------
    select first_name||' '||last_name as name,
           salary,
           e.department_id
      from employees e
     where salary=(select min(salary) from employees e where department_id=e.department_id)
--2.Clara ishlediyi departamentde ishleyen ishcilerin ad soyad hire date gosteren sorgu yazin, 
--lakin Claranin ozu son neticede olmasin. 
    select department_id from employees e where first_name='Clara'
    ----------------------------------------------------------------------------
    select first_name,
           last_name,
           hire_date
      from employees e
      where department_id=(select department_id from employees e where first_name='Clara')
            and first_name!='Clara'
--3.Department adi, ortalama maash(salary), ve komissiya ile ishleyen ishcilerin sayini gosteren sorgu yazin(employees, departments)
    select (select department_name from departments d where e.department_id=d.department_id) as dep_name,
            avg(salary),
           count(commission_pct)
           from employees e
           group by e.department_id 
           having count(commission_pct)>0
--4.Ishcinin job_title, full_name (first and last name) ve maximum maashi ile salary-si arasinda ferqi tapan sorgu yazin(employees, jo--bs cedvelleri)
    select (select job_title from jobs j where e.job_id=j.job_id) as job_title,
            first_name||' '||last_name as full_name,
            (select max_salary from jobs j where e.job_id=j.job_id)-e.salary as Ferq
            from employees e
--5.ID-si 163 olan ishciden daha cox maash alan ishcilerin siyahisini(first name ve last name) gosteren sorgu yazin.
    select salary from employees e where employee_id=163
    ---------------------------------------------------------------------------
    select first_name,
           last_name,
           salary
           from employees e
           where salary>(select salary from employees e where employee_id=163)

--6.ID-si 169 olan ishci ile eyni ishi goren ishcilerin siyahisini cixaran sorgu yazin.
    select job_id from employees e where employee_id= 169
    ---------------------------------------------------------------------------
    select *
      from employees e
      where job_id=(select job_id from employees e where employee_id= 169)
--7.Manager id-si 120 ve 150 arasinda olan ishcilerin ishlediyi departamentde ishlemeyen ishcilerin siyahisini gosteren sorgu yazin
    select department_id from employees e where manager_id between 120 and 150
    ----------------------------------------------------------------------------
    select *
      from employees e
      where department_id not in (select department_id from employees e where manager_id between 120 and 150)
--8**. ikinci en yuksek maashi alan ishcinin ad soyad ve maashini cixaran sorgu yazin
    select max(salary) from employees e
    select first_name,
           last_name,
           salary
           from employees e
           order by salary
           offset 1 rows
           fetch first 2 rows only
       
           
--9. Departamentlər üzrə minimal əmək haqqısı 10 nömrəli departamentdəki maksimal əmək haqqından çox olan departamentlərin adını, 
--departament nömrəsini   və minimal əmək haqqını ekrana çıxaran sorğunu yazın.                                   
    select max(salary) from employees e where e.department_id=10
    --------------------------------------------------------------------------
    select (select department_name from departments d where e.department_id=d.department_id) as dep_name,
            e.department_id,
            min(salary)
      from employees e
      group by department_id
      having min(salary)>( select max(salary) from employees e where e.department_id=10)
--10. 10 nömrəli departamentdəki əmək haqqına bərabər əmək haqqı alan əməkdaşların adını, soyadını, işə qəbul tarixini, 
--departament nömrəsini, departamentin adını, şəhəri, ölkə kodunu və ölkənin adını ekrana çıxaran sorğunu yazın.
    select salary from employees e where department_id=10
    ----------------------------------------------------------------------------
    select e.first_name,
           e.last_name,
           e.hire_date,
           e.department_id,
          (select d.department_name  from departments d where d.department_id=e.department_id) as dep_name,
          (select l.city from locations l where l.location_id=d.location_id) as city,
          (select l.country_id from locations l where l.location_id=d.location_id) as olke_kodu,
          (select c.country_name from countries c where l.country_id=c.country_id) as olke_adi
          from employees e
          where salary = (select salary from employees e where e.department_id=10)
          
          select e.first_name,
           e.last_name,
           e.hire_date,
           e.department_id,
           d.department_name,
           l.city,
           l.country_id,
           c.country_name
           from employees e
           inner join departments d
           on e.department_id=d.department_id
           inner join locations l
           on d.location_id=l.location_id
           inner join countries c
           on l.country_id=c.country_id
           where salary = (select salary from employees e where department_id=10)
--11. 121 və 200 nömrəli əməkdaşla eyni departamentdə və eyni menecerə tabe olan əməkdaşların siyahını əks etdirən sorğunu yazın.
    select manager_id,department_id from employees e where employee_id in (121,200)
    ----------------------------------------------------------------------------
    select *
      from employees e
      where (manager_id,department_id) in (select manager_id,department_id from employees e where employee_id in (121,200))
--12. Vəzifəsi SA_REP olan əməkdaşlar içərisində ən yüksək əmək haqqı alan əməkdaşı tapın.
    select max(salary) from employees e where job_id='SA_REP'
    ----------------------------------------------------------------------------
    select employee_id,
           first_name||' '||last_name as full_name,
          salary
      from employees e
      where salary=(select max(salary) from employees e where job_id='SA_REP')
--13. 80 nömrəli departamentdə əmək haqqısı vəzifəsi SA_REP olan əmədaşlar arasında maksimum əmək haqqına bərabər olan sorğunu yazın. 
--Sorğunun nəticəsini ada görə sıralayın.
    select salary from employees where department_id=80
    select max(salary) from employees where job_id='SA_REP'
    ---------------------------------------------------------------------------
    select *
      from employees 
      where (select max(salary) from employees where job_id='SA_REP')in
      (select salary from employees where department_id=80)
      order by first_name
--14. Adı böyük T hərfi ilə başlayan şəhərlərdə (locations cədvəli) işləyən işçilərin employee_id, last_name və job_id haqqında məlumatları göstərin.
    select city from locations l where substr(l.city,1,1)='T'
    ----------------------------------------------------------------------------
    select e.employee_id,
           e.last_name,
           e.job_id,
           substr(l.city,1,1)='T' as city
           from employees e
           inner join departments d
           on e.department_id=d.department_id
           inner join locations l
           on l.location_id=d.location_id
