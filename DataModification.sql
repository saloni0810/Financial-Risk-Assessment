create database Financial_Risk_Analysis;
use Financial_Risk_Analysis;

select * from loan;

set SQL_SAFE_UPDATES = 1;

update loan
set ApplicationDate = str_to_date(ApplicationDate, '%d-%m-%Y')
where ApplicationDate Like '%-%-%';

alter table loan
modify ApplicationDate Date;