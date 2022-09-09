USE PortfolioProject
GO
DROP VIEW IF EXISTS tableautable3
GO
CREATE VIEW tableautable3
AS
Select Location, Population, ISNULL(MAX(total_cases),0) as HighestInfectionCount,  ISNULL(Max((total_cases/population))*100,0) as PercentPopulationInfected
From PortfolioProject..['CovidDeaths']
Group by Location, Population