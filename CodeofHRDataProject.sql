select * from HRProject.dbo.hrdata

select Termdate from hrdata
order by Termdate DESC;

update hrdata
SET termdate = Format(convert(datetime, Left(termdate, 19), 120), 'yyyy-MM-dd')

ALter table hrdata
ADD new_termdate DATE;

Update hrdata
SET new_termdate = CASE
When termdate is not null and ISDATE(termdate) = 1 then CAST (termdate as Datetime) ELSE null END; 

ALter table hrdata
ADD age nvarchar(50);

update hrdata
SET age = datediff(YEAR, birthdate, getdate());

select age
from hrdata

select 
MIN(age) as youngest,
MAX(age) as oldest
From hrdata;

select age_group,
count(*) AS count
From
(select 
	CASE 
	WHEN age >= 20 And age <= 30 Then '21 to 30'
	when age >= 31 And age <= 40 Then '31 to 40'
	when age >= 41 and age <= 50 then '41 to 50'
	ELSE '50+'
	END AS age_group
FRom hrdata
Where new_termdate is null
) as subquery
Group by age_group
order by age_group;

select age_group, gender,
count(*) AS count
From
(select 
	CASE 
	WHEN age >= 20 And age <= 30 Then '21 to 30'
	when age >= 31 And age <= 40 Then '31 to 40'
	when age >= 41 and age <= 50 then '41 to 50'
	ELSE '50+'
	END AS age_group, 
	gender
FRom hrdata
Where new_termdate is null
) as subquery
Group by age_group, gender
order by age_group, gender;

select gender, 
count(gender) as GenderCount
From hrdata
Where new_termdate is null
Group by gender
Order by gender ASC

select gender, department, jobtitle,
count(gender) as GenderCount
From hrdata
Where new_termdate is null
Group by department, jobtitle, gender
Order by department, jobtitle, gender ASC

select race, 
count(*) AS Count
From hrdata
where new_termdate is NULL
Group by race 
ORder by count DESC;

select AVG(datediff(year, hire_date, new_termdate)) AS tenure
From hrdata
where new_termdate is not null and new_termdate <= GETDATE();

Select department, 
total_count, 
terminated_count,
(round((CAST(terminated_count AS FLOAT)/total_count), 3)) * 100 AS turnover_rate
FRom
(select department, 
count(*) as total_count, 
SUM(CASE 
When new_termdate is not null and new_termdate <= GETDATE() THEN 1
ELSE 0 
END) AS terminated_count
From hrdata
Group by department)
AS subquery 
ORDER by turnover_rate DESC;


select location, 
count(*) as LocCOUNT
From hrdata
WHERE new_termdate is null
GROUP BY location;

Select location_state,
count(*) AS locCOUNT
FRom hrdata
where new_termdate is null
Group by location_state
ORDER BY locCOUNT DESC;

select jobtitle, 
count(*) as count
FRom hrdata
where new_termdate is Null
Group by jobtitle
ORder by count DESC;

select * 
from hrdata