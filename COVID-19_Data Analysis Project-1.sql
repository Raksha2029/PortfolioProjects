SELECT *
FROM Portfolio_Project1..covid_deaths
WHERE continent IS NOT NULL

SELECT *
FROM Portfolio_Project1..covid_vaccinations
WHERE continent IS NOT NULL


--Select the data that we are going to work with

SELECT
	location,
	date,
	total_cases,
	new_cases, 
	total_deaths
FROM 
	Portfolio_Project1..covid_deaths
ORDER BY 1,2


--Examining total_cases vs total_deaths
 
SELECT
	location,
	date,
	total_cases, 
	total_deaths,
	(total_deaths / total_cases) * 100 AS death_Percentage
FROM 
	Portfolio_Project1..covid_deaths
ORDER BY 1,2


--Examining total_cases vs total_deaths for INDIA
 
SELECT
	location,
	date,
	total_cases, 
	total_deaths,
	(total_deaths / total_cases) * 100 AS death_Percentage
FROM 
	Portfolio_Project1..covid_deaths
WHERE
	location = 'India'


--Query for highest infection count of different countries

SELECT
	location,
	MAX(CAST(total_cases AS INT)) AS highest_infection_count	
FROM 
	Portfolio_Project1..covid_deaths	
--WHERE
--	location = 'India'
WHERE continent IS NOT NULL
GROUP BY
	location
ORDER BY
	highest_infection_count DESC
	

--Query for highest death count of different countries

SELECT
	location,
	MAX(CAST(total_deaths AS int)) AS highest_death_count
FROM
	Portfolio_Project1..covid_deaths
--WHERE
--	location = 'India'
WHERE continent IS NOT NULL
GROUP BY
	location
ORDER BY
	highest_death_count DESC


-- Examining based on continents

SELECT
	continent,
	MAX(CAST(total_cases AS INT)) AS highest_infection_count,
	MAX(CAST(total_deaths AS int)) AS highest_death_count		
FROM
	Portfolio_Project1..covid_deaths
WHERE continent IS NOT NULL
GROUP BY
	continent

	
-- GLOBAL NUMBERS

SELECT
	date,
	SUM(new_cases) AS total_new_cases,
	SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	--(total_new_deaths / total_new_cases) * 100 AS global_death_percentage
	((SUM(CAST(new_deaths AS float))) / (SUM(CAST(new_cases AS float)))) * 100 AS global_death_percentage
FROM 
	Portfolio_Project1..covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


--global death percentage

SELECT
	--date,
	SUM(new_cases) AS total_new_cases,
	SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	--(total_new_deaths / total_new_cases) * 100 AS global_death_percentage
	((SUM(CAST(new_deaths AS float))) / (SUM(CAST(new_cases AS float)))) * 100 AS global_death_percentage
FROM 
	Portfolio_Project1..covid_deaths
WHERE
	continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2


--New vaccinations per day

SELECT 
	Deaths.continent, 
	Deaths.location, 
	Deaths.date, 
	Vaccination.new_vaccinations
FROM 
	Portfolio_Project1..covid_deaths Deaths
JOIN 
	Portfolio_Project1..covid_vaccinations Vaccination
	ON Deaths.location = Vaccination.location
	AND Deaths.date = Vaccination.date
WHERE Deaths.continent IS NOT NULL


--Rolling_People_Vaccinated 

SELECT 
	Deaths.continent, 
	Deaths.location, 
	Deaths.date, 
	Vaccination.new_vaccinations,
	SUM(CONVERT(INT, Vaccination.new_vaccinations)) OVER (PARTITION BY Deaths.location ORDER BY Deaths.location, Deaths.date) AS Rolling_People_Vaccinated
FROM 
	Portfolio_Project1..covid_deaths Deaths
JOIN 
	Portfolio_Project1..covid_vaccinations Vaccination
	ON Deaths.location = Vaccination.location
	AND Deaths.date = Vaccination.date
WHERE Deaths.continent IS NOT NULL


--Creating view to store data 

CREATE VIEW global_numbers AS
SELECT
	date,
	SUM(new_cases) AS total_new_cases,
	SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	--(total_new_deaths / total_new_cases) * 100 AS global_death_percentage
	((SUM(CAST(new_deaths AS float))) / (SUM(CAST(new_cases AS float)))) * 100 AS global_death_percentage
FROM 
	Portfolio_Project1..covid_deaths
WHERE
	continent IS NOT NULL
GROUP BY date



CREATE VIEW highestDeathCountOfDifferentCountries AS
SELECT
	location,
	MAX(CAST(total_deaths AS int)) AS highest_death_count
FROM
	Portfolio_Project1..covid_deaths
--WHERE
--	location = 'India'
WHERE continent IS NOT NULL
GROUP BY
	location



CREATE VIEW Continents AS
SELECT
	continent,
	MAX(CAST(total_cases AS INT)) AS highest_infection_count,
	MAX(CAST(total_deaths AS int)) AS highest_death_count		
FROM
	Portfolio_Project1..covid_deaths
WHERE continent IS NOT NULL
GROUP BY
	continent

