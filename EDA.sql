-- Exploratory Data Analysis (EDA) is the process of examining and 
-- understanding a dataset before applying statistical models 
USE world_layoffs;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *FROM layoffs_staging2
WHERE percentage_laid_off IN (
SELECT MAX(percentage_laid_off)
FROM layoffs_staging2
) ORDER BY total_laid_off DESC;

SELECT *FROM layoffs_staging2
WHERE percentage_laid_off IN (
SELECT MAX(percentage_laid_off)
FROM layoffs_staging2
) ORDER BY funds_raised_millions DESC;

SELECT company , SUM(total_laid_off) as s
FROM 
layoffs_staging2 GROUP BY company
ORDER BY s DESC;

SELECT country, SUM(total_laid_off) as s
FROM layoffs_staging2 GROUP BY country
ORDER BY s DESC;

SELECT industry, SUM(total_laid_off) as s
FROM layoffs_staging2 GROUP BY industry
ORDER BY s DESC;

SELECT MAX(DATE),MIN(DATE)
FROM layoffs_staging2;


SELECT YEAR(date), SUM(total_laid_off) as s
FROM layoffs_staging2 GROUP BY YEAR(date)
ORDER BY s DESC;

-- PROGRESSION OF THE LAYOFFS USING THE ROLLING FUNCTION BASED IN THE MONTH

SELECT SUBSTRING(DATE,1,7) AS TIMELINE
FROM layoffs_staging2
ORDER BY TIMELINE ASC;

USE world_layoffs;
SELECT  SUBSTRING(DATE,1,7) AS `MONTH`,SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(DATE,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY `MONTH` ASC;


WITH ROLLING_TOTAL AS(
SELECT SUBSTRING(DATE, 1,7) AS MONTH , SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(DATE, 1,7) IS NOT NULL
GROUP BY MONTH
ORDER BY MONTH asc
)
SELECT MONTH ,total_off, SUM(total_off)
OVER(ORDER BY MONTH asc) as rolling_laid_off
from ROLLING_TOTAL;

SELECT company , year(`date`), sum(total_laid_off) as sm
FROM layoffs_staging2
GROUP BY company , year(`date`)
ORDER By sm desc;


-- Ranking the comapny layoffs based on year 
-- FINDING OUT THE COMPANY WHICH HAD THE MAXIMUM LAYOFFS YEARLY

WITH max_layoffs (company,my_year,sm) AS (
SELECT company,YEAR(date), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, YEAR(date)
),company_rank AS
(SELECT *,
DENSE_RANK() OVER(Partition by my_year ORDER BY sm DESC) as den_rank
FROM max_layoffs
WHERE my_year IS NOT NULL

) SELECT * FROM company_rank
WHERE den_rank <= 5;




