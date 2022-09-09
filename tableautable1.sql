USE PortfolioProject
GO
DROP VIEW IF EXISTS tableautable1
GO
CREATE VIEW tableautable1
AS
Select SUM(total_cases) as Total_Cases, SUM(cast(total_deaths as bigint)) as Total_Deaths, (SUM(cast(total_deaths as bigint))/SUM(total_cases))*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
Where continent is not null