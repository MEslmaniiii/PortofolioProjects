Select *
from portofolioproject ..CovidDeaths$
where continent is not null 
order by 3,4

--Select *
--from portofolioproject ..CovidVaccinations$
--order by 3,4

--select data that we are going to use 

Select  location,  date, total_cases, new_cases, total_deaths, population 
from portofolioproject ..CovidDeaths$
order by 1,2 



-- looking at totalcases vs total deaths 

Select  location,  date, total_cases, total_deaths,(total_deaths/total_cases)* 100 as deathpercantegs 
from portofolioproject ..CovidDeaths$
where location like 'egypt%'
order by 1,2

-- total cases vs population 

Select  location,  date,population, total_cases ,(total_cases/population)* 100 as POPpercantegs 
from portofolioproject ..CovidDeaths$
where location like 'egypt%'
order by 1,2

-- looking at countries with highest infection rate comapred to population 
Select  location, population, max (total_cases)as highestinfectioncounut ,max (total_cases/population)* 100 as ppinfected  
from portofolioproject ..CovidDeaths$
--where location like 'egypt%'
group  by location , population
order by  ppinfected desc

-- showing countries with highest death countr per poplution 

Select  location,  max (cast(Total_deaths as int)) as TotalDeathCount
from portofolioproject ..CovidDeaths$
--where location like 'egypt%'
where continent is not null 
group  by location 
order by  totaldeathCount desc

-- lets break things down by  continent

Select  continent,  max (cast(Total_deaths as int)) as TotalDeathCount
from portofolioproject ..CovidDeaths$
--where location like 'egypt%'
where continent is not null 
group  by continent 
order by  totaldeathCount desc


-- showing the continents with the highest death count per population 

Select  continent,  max (cast(Total_deaths as int)) as TotalDeathCount
from portofolioproject ..CovidDeaths$
--where location like 'egypt%'
where continent is not null 
group  by continent 
order by  totaldeathCount desc

---- global number 
Select sum(new_cases) as total_cases ,sum(cast(new_deaths as int))as total_deaths ,sum(cast(new_deaths as int )) /sum
(new_cases  )/ sum (new_cases )*100 as deathpercentages
from portofolioproject ..CovidDeaths$
where continent is not null
--group by date
order by 1,2


-- looking at total population vs vaccinations
Select  dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location, dea.date) as
rollingpeoplevac
from portofolioproject ..CovidDeaths$  dea
join portofolioproject ..CovidVaccinations$  vac
     
	 on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 -- Using CTE
 
 with popvsVac (continent, location,date,population,new_vaccinations, rollingpeoplevac)
 as
 (
 Select  dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location, dea.date) as
rollingpeoplevac
from portofolioproject ..CovidDeaths$  dea
join portofolioproject ..CovidVaccinations$  vac
     
	 on dea.location = vac.location
	 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 )

 select*, (rollingpeoplevac/population)*100
 from popvsVac




 -- Temp Table 




 drop table if exists #percentpopulationvac
 create table #percentpopulationvac
 (
 continent nvarchar(255) ,
 location varchar(255),
 date datetime,
 population numeric,
 new_vaccination numeric,
 rollingpeoplevac numeric 
 )

 insert into  #percentpopulationvac
 Select  dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location, dea.date) as
rollingpeoplevac
from portofolioproject ..CovidDeaths$  dea
join portofolioproject ..CovidVaccinations$  vac
     
	 on dea.location = vac.location
	 and dea.date = vac.date
-- where dea.continent is not null
 --order by 2,3

 select *, (rollingpeoplevac/population)*100
 from #percentpopulationvac


 -- creating view to stored data for later visualizations



 create view percentpopulationvac as 

 Select  dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int) ) over (partition by dea.location order by dea.location, dea.date) as
rollingpeoplevac
from portofolioproject ..CovidDeaths$  dea
join portofolioproject ..CovidVaccinations$  vac
     
	 on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationvac
