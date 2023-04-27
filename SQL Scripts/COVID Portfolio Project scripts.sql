/*
Covid 19 Data Exploration 

Skills: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

/* Select * 
From PortfolioProject..CovidVacinations
order by 3,4 */

-- Select Data that we are going to be using 

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying from covid if contracted

Select location, date, total_cases, total_deaths, (total_deaths*1.0/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


-- Total cases vs Population
-- Shows Covid population percentage

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Countries with highest infection rate compared to population

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
order by PercentPopulationInfected desc 


-- Country death count by population

Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc 


-- BREAK THINGS DOWN BY CONTINENT


-- Continent Death Counts

Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc 


-- GLOBAL NUMBERS


-- Covid Death Percentage
Select date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/nullif(SUM(new_cases), 0) as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVacCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, New_Vaccinations, RollingVacCount)
as
(
-- Total population vs vaccinations 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVacCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
-- order by 2,3
)
Select *, (RollingVacCount/population)*100
From PopvsVac

-- -- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingVacCount numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVacCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
-- order by 2,3

Select *, (RollingVacCount/population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualizations 

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingVacCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVacinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select * 
From PercentPopulationVaccinated


/* 

Queries for Tableau Project

*/

-- 1.

-- Covid Death Percentage

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/nullif(SUM(new_cases)*100, 0) as 
 DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- 2

-- Remove these as they are not included in the above queries and want to stay consistent 
-- European Union is part of Europe

Select continent, SUM(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
and location not in ('World', 'European Union', 'International')
Group by continent
order by TotalDeathCount desc 


-- 3 

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population
order by 1,2


-- 4

Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases)/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location, population, date
order by PercentPopulationInfected desc 