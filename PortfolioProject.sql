Select *
From PortfolioProject..['CovidDeaths']
Where continent is not null
order by 3,4

Select *
From PortfolioProject.dbo.['CovidVaccinations']
Where continent is not null
order by 3,4

--Select Data

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['CovidDeaths']
Where continent is not null
Order by 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract covid by country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
Where location like '%states%'
Order by 1,2

--Looking at total cases vs population
Select Location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage
From PortfolioProject..['CovidDeaths']
Where location like '%North Korea%'
Order by 1,2

--Looking at Countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases)/population*100 as InfectionPercentage
From PortfolioProject..['CovidDeaths']
--Where location like '%states%'
Group by Location, population
Order by InfectionPercentage desc

--Showing countries with highest death count per population
Select Location, population, MAX(cast(total_deaths as int)) as HighestDeathCount, MAX((total_deaths)/population)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by Location, population
Order by DeathPercentage desc

--Break things down by continent
Select Location, MAX(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..['CovidDeaths']
Where continent is null
Group by Location
Order by HighestDeathCount desc

--showing the continent with the highest death count
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global numbers
Select date, SUM(total_cases) as TotalCaseDay, SUM(cast(total_deaths as int)) as TotalDeathDay, (SUM(cast(total_deaths as int))/SUM(total_cases))*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
--Where location like '%states%'
Where continent is not null
Group by date
Order by TotalDeathDay desc

Select SUM(total_cases) as TotalCaseDay, SUM(cast(total_deaths as BIGINT)) as TotalDeathDay, (SUM(cast(total_deaths as BIGINT))/SUM(total_cases))*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
--Where location like '%states%'
Where continent is not null
Order by TotalDeathDay desc

Select * 
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date

--looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--use CTE
WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)
FROM PopvsVac

--Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

SELECT *, (RollingPeopleVaccinated/Population)
FROM #PercentPopulationVaccinated


--CREATE VIEW TO STORE DATA FROM LATER VISUALIZATIONS
CREATE VIEW PortfolioProject.PercentPopulationVaccinated 
as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

Select * 
from PortfolioProject.dbo.percentpopulationvaccinated
