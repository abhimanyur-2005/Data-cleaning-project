-- DATA CLEANING
SELECT * FROM layoffs;

 create TABLE layoffs_staging 
 like layoffs;
  SELECT *
FROM layoffs_staging;

insert  layoffs_staging
select *
from layoffs;

with duplicate_cte as(
  SELECT *, row_number() over( partition by company , location,industry,
  total_laid_off, percentage_laid_off,`date`, stage,country,funds_raised_millions)
  as row_numb
FROM layoffs_staging)

select * from duplicate_cte 
where company = 'Oyster';


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
  `row_numb` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
SELECT *, row_number() over( partition by company , location,industry,
  total_laid_off, percentage_laid_off,`date`, stage,country,funds_raised_millions)
  as row_numb
FROM layoffs_staging;

select * from layoffs_staging2
where row_numb >1;

select company , trim(company)
 from layoffs_staging2;
 
 update layoffs_staging2
 set company = trim(company);
 
 select distinct industry 
 from layoffs_staging2
 order by 1;
 
  select distinct country , trim(trailing '.' from country)
 from layoffs_staging2
 order by 1;

 update layoffs_staging2
 set country = trim(trailing '.' from country)
 where country like 'united states%';
 
 select `date`,
 str_to_date(`date` , '%m/%d/%Y')
 from layoffs_staging2;
 
update layoffs_staging2
set `date` = str_to_date(`date` , '%m/%d/%Y');

 select *
 from layoffs_staging2
 where total_laid_off is null and percentage_laid_off is null
;

update layoffs_staging2 set 
industry = null
where industry = '';
 select *
 from layoffs_staging2
where industry is null or industry = '';

 select *
 from layoffs_staging2
 where company = 'airbnb';
 
  select t1.industry,t2.industry
 from layoffs_staging2
 as t2
 join layoffs_staging2 t1 
 on t1.company = t2.company
 and t2.location = t1.location
 where (t2.industry is null or t1.industry = '')
 and t1.industry is not null;
 
 
 select *
 from layoffs_staging2
 where total_laid_off is null and percentage_laid_off is null
;
 
 delete  from layoffs_staging2
 where total_laid_off is null and percentage_laid_off is null
;
select * from layoffs_staging2;

alter table layoffs_staging2
drop column row_numb;
 
 
 
 
 
 
 
 
