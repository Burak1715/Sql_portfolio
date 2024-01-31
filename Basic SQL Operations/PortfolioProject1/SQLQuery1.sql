--Deciding required data
select CompanyData.EmployeeID, First_Name, Surname, Gender, Gender_Identity, Race_Ethnicity, Disability, Education, Sexual_Orientation, Office, Start_Date, Termination_Date, Office_Type, Department, Currency, Job_title, level, Salary
from PortfolioProject1..CompanyData
join PortfolioProject1..Diversity on CompanyData.EmployeeID = Diversity.EmployeeID
order by 1

--Creating empty table with data
--create table PortfolioProject1..AllData
--(
--EmployeeID INT,
--First_Name VARCHAR(255),
--Surname VARCHAR(255),
--Gender VARCHAR(255),
--Gender_Identity VARCHAR(255),
--Race_Ethicity VARCHAR(255),
--Disability VARCHAR(255),
--Education VARCHAR(255),
--Sexual_Orientation VARCHAR(255),
--Office VARCHAR(255),
--Start_Date DATE,
--Termination_Date DATE,
--Office_Type VARCHAR(255),
--Department VARCHAR(255),
--Currency VARCHAR(255),
--Job_Title VARCHAR(255),
--Level VARCHAR(255),
--Salary INT
--);

--Inserting desired data into empty table
insert into PortfolioProject1..AllData (
EmployeeID, First_Name, Surname, Gender, Gender_Identity, 
Race_Ethicity, Disability, Education, Sexual_Orientation, 
Office, Start_Date, Termination_Date, Office_Type, Department,
Currency, Job_Title, Level, Salary
)
select CompanyData.EmployeeID, First_Name, Surname, Gender, Gender_Identity, 
Race_Ethnicity, Disability, Education, Sexual_Orientation, 
Office, Start_Date, Termination_Date, Office_Type, Department,
Currency, Job_title, level, Salary
from PortfolioProject1..CompanyData
join PortfolioProject1..Diversity on CompanyData.EmployeeID = Diversity.EmployeeID
order by 1;

--Checking the data
select *
from PortfolioProject1..AllData

--Basic operations

select count(*) as total_employee
from PortfolioProject1..AllData
--Total employees  4968

select Gender , count(*) as gender_amount
from PortfolioProject1..AllData
GROUP BY Gender;
--male	2570
--female	2398

select Gender_Identity , count(*) as gender_identity_amount
from PortfolioProject1..AllData
GROUP BY Gender_Identity;
--Prefer not to say	263
--male	2308
--female	2173
--Non-binary/third gender	140
--Prefer to self-describe	84

select Sexual_Orientation , count(*) as sexual_orientation_amount
from PortfolioProject1..AllData
GROUP BY Sexual_Orientation;
--Bisexual	104
--Gay	104
--Other LGBTQ+	192
--Lesbian	87
--Missing	1340
--Heterosexual	3141

select Disability , count(*) as disabled_amount
from PortfolioProject1..AllData
GROUP BY Disability;
--*Disabled employees = 210

select Race_Ethicity , count(*) as race_amount
from PortfolioProject1..AllData
GROUP BY Race_Ethicity;
--Black or African American	169
--Asian	1305
--Native Hawaiian or Pacific Islander	10
--Native Hawaiian or Other Pacific Islander	2
--Native American or Alaska Native	4
--NULL	549
--Two or More Races	52
--American Indian or Alaska Native	1
--White	2658
--Hispanic or Latino	218

select Education , count(*) as education_type
from PortfolioProject1..AllData
GROUP BY Education;
--Undergraduate	3288
--High School	857
--Some College	332
--PhD	139
--Graduate	352

--Analyze operations

select Currency, count(*) as currency_amount
from PortfolioProject1..AllData
group by Currency;
--USD	4446
--GBP	250
--JPY	50
--HKD	72
--NOK	150

--Creating currency rate table
--create table PortfolioProject1..CurrencyRates
--(
--currency_type VARCHAR(255),
--currency_rate_to_usd NVARCHAR(255)
--);


--Inserting currency rates (23.01.2024)
insert into PortfolioProject1..CurrencyRates (currency_type, currency_rate_to_usd) 
values ('USD', 1.0),
('GBP', 1.27),
('JPY' , 0.0068),
('HKD', 0.13),
('NOK', 0.095);

--Changing salary depending on currency rate by using CurrencyRates table
update PortfolioProject1..AllData
set Salary = Salary * cr.currency_rate_to_usd
from PortfolioProject1..AllData et
join PortfolioProject1..CurrencyRates cr on et.Currency = cr.currency_type;

--Changing currency type
UPDATE PortfolioProject1..AllData
SET Currency = 'USD'
WHERE Currency <> 'USD';

--Statistical operations

--Average salary of all employees
SELECT AVG(Salary) AS AverageSalary
FROM PortfolioProject1..AllData;
--Average Salary 73777

--Median of the salary
SELECT
    Salary
FROM
    PortfolioProject1..AllData
ORDER BY
    Salary
OFFSET (
    SELECT COUNT(*) / 2
    FROM PortfolioProject1..AllData
) ROWS
FETCH NEXT 1 ROWS ONLY;
--Median 74000

--Standard deviation and variance
SELECT
    STDEVP(Salary) AS StandardDeviation,
    VARP(Salary) AS Variance
FROM PortfolioProject1..AllData;
--24752,5980330803	612691109,387253

--Average salary by the departments
SELECT
    Department,
    AVG(Salary) AS AverageSalary
FROM PortfolioProject1..AllData
GROUP BY Department;
--Marketing	78960
--Sales	72021
--Corporate	67391
--Customer Service	55518
--Technology	86852

--Number of employees by department
SELECT
    Department,
    COUNT(EmployeeID) AS EmployeeCount
FROM PortfolioProject1..AllData
GROUP BY Department
ORDER BY EmployeeCount DESC;
--Technology	3830
--Customer Service	2436
--Sales	1698
--Corporate	1110
--Marketing	862

--Average salary by gender
SELECT
    Gender,
    AVG(Salary) AS AverageSalary
FROM PortfolioProject1..AllData
GROUP BY Gender;
--male	74849
--female	72628

SELECT
    Job_Title,
    AVG(Salary) AS AverageSalary,
    MAX(CASE WHEN Gender = 'male' THEN 1 ELSE 0 END) AS MaleCount,
    MAX(CASE WHEN Gender = 'female' THEN 1 ELSE 0 END) AS FemaleCount
FROM
    PortfolioProject1..AllData
GROUP BY
    Job_Title;