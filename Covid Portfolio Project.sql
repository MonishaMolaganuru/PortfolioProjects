select * from PortfolioProject ..CovidDeaths
where continent is not null
order by 3,4


--select * from PortfolioProject ..CovidVaccinations
--order by 3,4

select location, date, total_cases,new_cases, total_deaths, population
from PortfolioProject ..CovidDeaths
order by 1, 2

--Percentage of total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from PortfolioProject ..CovidDeaths
where location like '%india%'
order by 1, 2

--Percentage of Population who got Covid

select location, date, population, total_cases,  (total_cases/population)*100 as Populationpercentage
from PortfolioProject ..CovidDeaths
where location like '%india%'
order by 1, 2

--Countries with Highest Infection Rate compared with Population

select location, population, Max(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentInfectedPopulation
from PortfolioProject ..CovidDeaths
--where location like '%india%'
group by location, population
order by PercentInfectedPopulation desc

--Countries with Highest Deaths Rate compared with Population

select location, Max(cast(total_deaths as int)) as TotalDeathCounts
from PortfolioProject ..CovidDeaths
--where location like '%india%'
where continent is not null
group by location
order by TotalDeathCounts desc

----Break things down by Continent

select continent, Max(cast(total_deaths as int)) as TotalDeathCounts
from PortfolioProject ..CovidDeaths
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCounts desc

--Global Numbers

select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProject ..CovidDeaths
--where location like '%india%'
where continent is not null
group by date
order by 1, 2

--Total Cases across the World

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProject ..CovidDeaths
--where location like '%india%'
where continent is not null
--group by date
order by 1, 2

--Total amount of people in the world that have been Vaccination

select * from PortfolioProject ..CovidDeaths  Dea
join PortfolioProject ..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date

select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location, Dea.Date) as ConsecutiveNumbersofPeopleVaccinated
from PortfolioProject ..CovidDeaths  Dea
join PortfolioProject ..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
order by 2, 3

--ConsecutiveNumbersofPeopleVaccinated VS Population

with VacVsPop (continent, location, date, population, new_vaccinations, ConsecutiveNumbersofPeopleVaccinated)
as
(
select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location, Dea.Date) as ConsecutiveNumbersofPeopleVaccinated
from PortfolioProject ..CovidDeaths  Dea
join PortfolioProject ..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
--order by 2, 3
)
select *, (ConsecutiveNumbersofPeopleVaccinated/population)*100 as PercentageVacVspop
from VacVsPop

--Temp Table

Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
ConsecutiveNumbersofPeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location, Dea.Date) as ConsecutiveNumbersofPeopleVaccinated
from PortfolioProject ..CovidDeaths  Dea
join PortfolioProject ..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
--where Dea.continent is not null
--order by 2, 3
select *, (ConsecutiveNumbersofPeopleVaccinated/population)*100 as PercentageVacVspop
from PercentPopulationVaccinated

--create view
drop View if exists PercentagePopulationVaccinated

Create View PercentagePopulationVaccinated as
select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location, Dea.Date) as ConsecutiveNumbersofPeopleVaccinated
from PortfolioProject ..CovidDeaths  Dea
join PortfolioProject ..CovidVaccinations Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
--order by 2, 3

select * from PercentagePopulationVaccinated












