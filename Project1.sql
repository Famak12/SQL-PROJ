--Select *
--FRom Coviddeaths
--order by 3,4

--Select * 
--FRom Covidvacs
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.dbo.Coviddeaths
order by 1,2 

-- looking at the total cases vs total deaths
-- shows the likely hood of dying of Covid in Pakistan today

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
From PortfolioProject.dbo.Coviddeaths
where location = 'Pakistan'
order by 1,2 

-- looking at the total cases vs population 

Select Location, date, total_cases, population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS CasesPerPopulation
From PortfolioProject.dbo.Coviddeaths
-- where location like '%states%'
order by 1,2 

-- Looking at countries with highest infection rate compared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))) * 100 AS PercentPopulation
From PortfolioProject.dbo.Coviddeaths
--where location = 'Pakistan'
Group by location, population
order by PercentPopulation DESC

-- countries with highest death count per population 

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.Coviddeaths
Where continent is Not Null
Group by Location
Order by TotalDeathCount DESC

--Select *
--From PortfolioProject.dbo.coviddeaths
--Where continent is Not Null
--order by 3, 4

-- LET'S BREAK THINGS DOWN BY CONTINENT

select Location, Max(cast(total_cases as int)) as TotalInfectionsPerContinent
From PortfolioProject.dbo.Coviddeaths
Where continent is null AND Location not like '%income%'
Group by location 
ORder by TotalInfectionsPerContinent DESC

-- total deaths per continent

select Location, Max(cast(total_deaths as int)) as TotalDeathsPerContinent
From PortfolioProject.dbo.Coviddeaths
Where continent is null AND Location not like '%income%'
Group by location 
ORder by TotalDeathsPerContinent DESC

-- continents with highest death count 

Select Continent, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject.dbo.coviddeaths
where continent is not null
Group by continent
ORder by TotalDeaths DESC

-- GLOBAL NUMBERS

select Sum(new_Cases) as totalCases, Sum(cast(new_deaths as int)) as totalDeaths, Sum(cast(new_deaths as int))/ sum(new_cases)* 100 as DeathPErcentagePerCases
FRom PortfolioProject.dbo.coviddeaths
Where continent is not NULL
ORDER by 1, 2 

-- looking at Total Population Vs Total Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FRom PortfolioProject.dbo.Coviddeaths as dea
Join PortfolioProject.dbo.Covidvacs as vac
	ON dea.date = vac.date
	AND dea.location = vac.location
Where dea.continent is not NULL
Order by 2,3

-- looking at Total Population vs Vaccinations 

Select dea.continent, dea.location, dea.date, dea.population, vacs.new_vaccinations
, SUM(cast(vacs.new_vaccinations as bigint)) OVER (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
FRom PortfolioProject.dbo.Coviddeaths dea
Join PortfolioProject.dbo.Covidvacs vacs
ON dea.location = vacs.location
AND dea.date = vacs.date
where dea.continent is not NULL
order by 2,3

-- USE CTEs (always execute the select statement with the with CTE)

with PopvsVac (continent, locatiom ,date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vacs.new_vaccinations
, SUM(cast(vacs.new_vaccinations as bigint)) OVER (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
FRom PortfolioProject.dbo.Coviddeaths dea
Join PortfolioProject.dbo.Covidvacs vacs
ON dea.location = vacs.location
AND dea.date = vacs.date
where dea.continent is not NULL
-- order by 2,3
)

Select *
From PopvsVac

-- Temp Table

DROP TABLE IF EXISTS #percentpopulationcaccinated

Create Table #percentpopulationcaccinated
(
Continent nvarchar (255),
location nvarchar(255),
Date datetime, 
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #percentpopulationcaccinated
Select dea.continent, dea.location, dea.date, dea.population, vacs.new_vaccinations
, SUM(cast(vacs.new_vaccinations as bigint)) OVER (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population) * 100
FRom PortfolioProject.dbo.Coviddeaths dea
Join PortfolioProject.dbo.Covidvacs vacs
ON dea.location = vacs.location
AND dea.date = vacs.date
where dea.continent is not NULL
-- order by 2,3

select * , (RollingPeopleVaccinated/population) * 100 as newcol
From #percentpopulationcaccinated


-- VIEW

Create View PercentpopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vacs.new_vaccinations
, SUM(cast(vacs.new_vaccinations as bigint)) OVER (partition by dea.location Order by dea.location,
dea.date) as RollingPeopleVaccinated
FRom PortfolioProject.dbo.Coviddeaths dea
Join PortfolioProject.dbo.Covidvacs vacs
ON dea.location = vacs.location
AND dea.date = vacs.date
where dea.continent is not NULL
-- order by 2,3

Select * 
from PercentpopulationVaccinated