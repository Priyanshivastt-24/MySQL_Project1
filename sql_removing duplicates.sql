-- DATA CLEANING

SELECT * FROM layoffs;

-- CREATING A TABLE SIMILAR TO LAYOFFS 
CREATE TABLE layoffs_staging
LIKE layoffs;

-- INSERT VALUES FROM THE LAYOFFS
INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

-- FINDING DUPLICATE DATA 
-- For finding the duplicate we will assign row number to each group based on the company,industry,total_laid_off,percentage_laid_off,date

-- SELECT *FROM ( SELECT *,
-- ROW_NUMBER() OVER(partition by company,industry,total_laid_off,percentage_laid_off,`date`) row_num
-- FROM layoffs_staging) AS different 
-- WHERE row_num > 1;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

SELECT * FROM layoffs WHERE company = 'Oda';
-- YOU CANNOT PERFORM UPDATE OPERATION ON ANY CTE WHETHER IT IS DELETE OR INSERT NOTHING 
-- SO BASICALLY THE BELOW QUERY IS NOT POSSIBLE 
-- WITH duplicate_cte AS 
-- (
-- SELECT *,
-- ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
-- FROM layoffs_staging
-- )
-- DELETE FROM duplicate_cte WHERE row_num > 1;


-- AGAIN NOT POSSIBLE 
-- you cannot delete directly from a subquery or derived table
-- DELETE FROM (SELECT *,
-- ROW_NUMBER() OVER(partition by company,industry,total_laid_off,percentage_laid_off,`date`) row_num
-- FROM layoffs_staging) AS different 
-- WHERE row_num > 1;

-- CREATE ANOTHER TABLE i.e layoffs_staging2

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- FAILED BECAUSE ORIGINALLY THE layoffs_staging2 didnot have THE row_num WE NEED TO EXTRACT 
-- INSERT layoffs_staging
-- SELECT * FROM layoffs_staging2
-- WHERE row_num = 1;

 -- -- -- --FAILED BECAUSE 
 -- -- -- -- WHERE clause is evaluated before the SELECT clause where ROW_NUMBER()
 -- -- -- --  is computed. Because row_num hasn't been calculated yet when WHERE runs,
 -- -- -- --  the query planner doesn't recognize it as a valid column.
-- INSERT layoffs_staging2
-- SELECT * ,
-- ROW_NUMBER() OVER ( PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions ) AS row_num
-- FROM layoffs_staging 
-- WHERE row_num < 2;

 
INSERT layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2 where row_num >1 ;
DELETE FROM layoffs_staging2 where row_num > 1;



