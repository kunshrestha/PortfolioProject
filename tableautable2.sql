USE PortfolioProject
GO
DROP VIEW IF EXISTS tableautable2
GO
Create view tableautable2
as
Select Location, SUM(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..['CovidDeaths']
Where continent is null
AND Location NOT IN ('World','Upper middle income','High income','Lower middle income','European Union','Low income','International')
Group by Location
