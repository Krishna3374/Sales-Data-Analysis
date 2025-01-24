create database amazon;
use amazon;

create table sales(
	invoice_id varchar(30) primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    vat decimal(6,4) not null,
    total decimal(10,4) not null,
    `date` date not null,
    `time` time not null,
    payment_mode varchar(15) not null,
    total_cost decimal(10,2) not null,
    gross_margin_percentage float not null,
    gross_income decimal(10,4) not null,
    rating decimal(3,1) not null
);

-- added additional features for easier data analysis and saved as view
create view sales_vw as
select *, case when hour(`time`) < 12 then 'Morning'
when hour(`time`) < 18 then 'Afternoon' else 'Evening'
end time_of_day, date_format(`date`, '%a') day_of_week,
date_format(`date`, '%b') month_name from sales;