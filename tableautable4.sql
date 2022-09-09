USE PortfolioProject
GO
DROP VIEW IF EXISTS tableautable4
GO
CREATE VIEW tableautable4
AS
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..['CovidDeaths']
--Where location like '%states%'
Group by Location, Population, date