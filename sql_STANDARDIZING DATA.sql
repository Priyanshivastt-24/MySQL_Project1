USE world_layoffs;
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- 2. STANDARDIZING DATA - finding issues in your data and then fixing it.
SELECT DISTINCT COMPANY 
FROM layoffs_staging2
ORDER BY company ASC;

-- ------------------------REMOVING THE WHITE SPACE 
UPDATE layoffs_staging2
SET company = TRIM(company);

-- -------------------------SAME DOMAIN BUT SLIGHTLY DIFFERENT 
-- -------------------------NAMES LIKE CRYPTO OR CRYPTOGRAPHY
SELECT * FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- ---------------------------UPDATE THE COUNTRY WHERE THERE IS AN ISSUE 

SELECT DISTINCT country 
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country ,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

SELECT distinct `country` 
FROM layoffs_staging2
ORDER BY 1 ;

-- ----------------------------------CONVERTING DATE FROM TEXT FORMAT TO STRING FORMAT
-- Common formats
-- Text format	MySQL format
-- 19-08-2026	%d-%m-%Y
-- 19/08/2026	%d/%m/%Y
-- 2026-08-19	%Y-%m-%d
-- 08/19/2026	%m/%d/%Y
-- 19-Aug-2026	%d-%b-%Y

-- %y means a 2-digit year, such as: 19-08-26

SELECT date FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(date, '%m/%d/%Y') as date_data
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

-- You can change a text/VARCHAR column to a DATE column using ALTER TABLE, but the existing text values must be in a format MySQL can convert.
-- For example, if your column contains:
-- 3/15/2023
-- 4/20/2023
-- you generally can't simply do:
-- ALTER TABLE layoffs_staging2
-- MODIFY `date` DATE;
-- because MySQL expects a standard date representation like:
-- 2023-03-15
 
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE ;


