-- REMOVING NULL
USE world_layoffs;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND 
percentage_laid_off IS NULL;


-- “populating data” generally means putting data into a column/table, 
-- especially filling in values that are currently empty (NULL).

SELECT industry
FROM layoffs_staging2
WHERE industry IS null
OR industry = "";

SELECT *
FROM layoffs_staging2
WHERE industry IS null
OR industry = "";

SELECT *
FROM layoffs_staging2
WHERE company = 'AirBnB';

SELECT t1.industry,t2.industry 
FROM layoffs_staging2 t1 
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = "")
AND (t2.industry IS NOT NULL AND t2.industry <> "");

UPDATE layoffs_staging2 t1
 JOIN layoffs_staging2 t2
 ON t1.company = t2.company 
 SET t1.industry = t2.industry 
 WHERE (t1.industry IS NULL OR t1.industry = "")
 AND (t2.industry IS NOT NULL AND t2.industry <> "");
 
-- THE MAIN ISSUE WAS WITH THE BLANKS YOU CAN EITHER GO WITH THE ABOVE SOLUTION OR 
-- BETTER CONVERT THE BLANKS TO NULL
-- LIKE THIS : UPDATE layoffs_staging2 
--             SET industry = NULL 
--             WHERE industry = "";

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND 
percentage_laid_off IS NULL;

-- THIS SHOWS DATA WHICH IS INACCURATE BEACUSE THE DATA IS ABOUT THE LAYOFFS BUT THESE SAY 0 LAYOFFS
-- SO WE REMOVE THIS .ITS NOT RELIABLE 

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND 
percentage_laid_off IS NULL;

-- BACK TO BEING THE ORIGINAL CLEAN DATA 
-- SO WE REMOVE ROW_NUM COLUMN

ALTER TABLE layoffs_staging2
DROP COLUMN ROW_NUM;