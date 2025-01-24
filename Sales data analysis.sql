use amazon;

-- a business question is followed by it's corresponding query

-- What is the count of distinct cities in the dataset? 
select count(distinct city) cities_count from sales_vw;

-- For each branch, what is the corresponding city?
select distinct branch, city from sales_vw;

-- What is the count of distinct product lines in the dataset?
select count(distinct product_line) product_lines_count from sales_vw;

-- Which payment method occurs most frequently?
select payment_mode, count(*) frequency from sales_vw
group by 1 order by 2 desc limit 1;

-- Which product line has the highest quantity sold?
select product_line, sum(quantity) sales_count from sales_vw
group by 1 order by 2 desc limit 1;

-- How much revenue is generated each month?
select month_name, sum(total) monthly_revenue from sales_vw
group by 1;

-- In which month did the cost of goods sold reach its peak?
select month_name, sum(total_cost) monthly_costs from sales_vw
group by 1 order by 2 desc limit 1;

-- Which product line generated the highest revenue?
select product_line, sum(total) total_revenue from sales_vw
group by 1 order by 2 desc limit 1;

-- In which city was the highest revenue recorded?
select city, sum(total) city_revenue from sales_vw
group by 1 order by 2 desc limit 1;

-- Which product line incurred the highest Value Added Tax?
select product_line, sum(vat) total_vat from sales_vw
group by 1 order by 2 desc limit 1;

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
with product_line_sales as (select product_line, sum(total) total_sales from sales_vw group by 1)
select *, case when total_sales > (select avg(total_sales) from product_line_sales)
then 'Good' else 'Bad' end product_line_performance from product_line_sales;

-- Identify the branch that exceeded the average number of products sold.
with branch_sales as (select branch, avg(quantity) avg_qty_sold from sales_vw group by 1)
select * from branch_sales where avg_qty_sold > (select avg(quantity) from sales_vw);

-- Which product line is most frequently associated with each gender?
with gender_products_frq as (select gender, product_line, count(*) frequency, rank() over
(partition by gender order by count(*) desc) frq_rank from sales_vw group by 1, 2)
select gender, product_line, frequency from gender_products_frq where frq_rank=1;

-- Calculate the average rating for each product line.
select product_line, avg(rating) avg_rating from sales_vw group by 1;

-- Count the sales occurrences for each time of day.
select day_of_week, time_of_day, count(*) sales_count from sales_vw
group by 1, 2 order by 1, 2;

-- Identify the customer type contributing the highest revenue.
select customer_type, sum(total) total_revenue from sales_vw
group by 1 order by 2 desc limit 1;

-- Determine the city with the highest VAT percentage.
select city, vat from sales_vw where vat = (select max(vat) from sales_vw);

-- Identify the customer type with the highest VAT payments.
select customer_type, sum(vat) total_vat from sales_vw
group by 1 order by 2 desc limit 1;

-- What is the count of distinct customer types in the dataset?
select count(distinct customer_type) customer_types_count from sales_vw;

-- What is the count of distinct payment methods in the dataset?
select count(distinct payment_mode) payment_modes_count from sales_vw;

-- Which customer type occurs most frequently?
select customer_type, count(*) frequency from sales_vw
group by 1 order by 2 desc limit 1;

-- Determine the predominant gender among customers.
with cust_genders_frq as (select customer_type, gender, count(*) frequency, rank() over
(partition by customer_type order by count(*) desc) frq_rank from sales_vw group by 1, 2)
select customer_type, gender, frequency from cust_genders_frq where frq_rank=1;

-- Examine the distribution of genders within each branch.
select branch, gender, count(*) frequency from sales_vw
group by 1, 2 order by 1, 3 desc;

-- Identify the time of day when customers provide the most number of ratings.
select time_of_day, count(rating) ratings_count from sales_vw
group by 1 order by 2 desc limit 1;

-- Determine the time of day with the highest customer ratings for each branch.
with branch_ratings as (select branch, time_of_day, max(rating) max_rating, row_number() over
(partition by branch order by max(rating) desc) rating_rank from sales_vw group by 1, 2)
select branch, time_of_day, max_rating from branch_ratings where rating_rank=1;

-- Identify the day of the week with the highest average ratings.
select day_of_week, avg(rating) avg_rating from sales_vw
group by 1 order by 2 desc limit 1;

-- Determine the day of the week with the highest average ratings for each branch.
with branch_ratings as (select branch, day_of_week, avg(rating) avg_rating, rank() over
(partition by branch order by avg(rating) desc) rating_rank from sales_vw group by 1, 2)
select branch, day_of_week, avg_rating from branch_ratings where rating_rank=1;