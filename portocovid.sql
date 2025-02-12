select * from PortoCovid..CovidDeaths
where continent is not null
order by 3,4

--select * from PortoCovid..CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population 
from PortoCovid..CovidDeaths
order by 1,2

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from PortoCovid..CovidDeaths
where location like '%Indonesia%'
order by 1,2

select Location, date, total_cases, population, (total_cases/population)*100 as case_percentage
from PortoCovid..CovidDeaths
where location like '%Indonesia%'
order by 1,2

select Location, population, max(total_cases) as highest_case, max(total_cases/population)*100 as highest_case_percentage
from PortoCovid..CovidDeaths
group by Location, Population
order by highest_case_percentage desc

select Location, max(cast(total_deaths as int)) as highest_death
from PortoCovid..CovidDeaths
where continent is null
group by Location
order by highest_death desc

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortoCovid..CovidDeaths
where continent is not null
group by date
order by 1,2




select * from PortoCovid..CovidVaccinations

With PopVsVac(continent, location, date, population, new_vaccinations, total_vac) as (
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as total_vac
from PortoCovid..CovidVaccinations vac
join PortoCovid..CovidDeaths dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null
)
select *, (total_vac/population)*100 as vacc_per_pop from PopVsVac

use PortoCovid
go
create view PercentPopVacc as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as total_vac
from PortoCovid..CovidVaccinations vac
join PortoCovid..CovidDeaths dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null

select * from PercentPopVacc