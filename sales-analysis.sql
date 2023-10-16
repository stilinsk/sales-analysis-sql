
/*
we have a shop where the owner wants to make sense of data while understanding which products have a better purchasing power

We have the following tables 
1.sales table - contains   cutomer Id ,order date, product id
2.members table - contains the customer id, join date
3. menu table- contains product id,product name,price

*/
 
CREATE DATABASE shop;

CREATE  TABLE  Sales(
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER);
  
INSERT INTO sales
	(customer_id, order_date, product_id)
VALUES
	('A', '2021-01-01', 1),
	('A', '2021-01-01', 2),
	('A', '2021-01-07', 2),
	('A', '2021-01-10', 3),
	('A', '2021-01-11', 4),
	('A', '2021-01-11', 5),
	('B', '2021-01-01', 2),
	('B', '2021-01-02', 2),
	('B', '2021-01-04', 4),
	('B', '2021-01-11', 9),
	('B', '2021-01-16', 12),
	('B', '2021-02-01', 8),
	('C', '2021-01-01', 6),
	('C', '2021-01-01', 7),
	('C', '2021-01-07', 6),
	('D', '2021-01-01', 1),
	('D', '2021-01-02', 1),
	('D', '2021-01-04', 3),
	('D', '2021-01-11', 2),
	('D', '2021-01-16', 12),
	('D', '2021-02-01', 5),
	('E', '2021-01-01', 6),
	('E', '2021-01-01', 7),
	('E', '2021-01-07', 8),
	('E', '2021-01-10', 1),
	('E', '2021-01-11', 4),
	('E', '2021-01-11', 5),
	('F', '2021-01-01', 6),
	('F', '2021-01-01', 7),
	('F', '2021-01-07', 8),
	('F', '2021-01-10', 1),
	('F', '2021-01-11', 2),
	('F', '2021-01-11', 3),
	('G', '2021-01-01', 4),
	('G', '2021-01-02', 5),
	('G', '2021-01-04', 6),
	('G', '2021-01-11', 7),
	('G', '2021-01-16', 8),
	('G', '2021-02-01', 9),
	('H', '2021-01-01', 10),
	('H', '2021-01-01', 11),
	('H', '2021-01-07', 12),
	('I', '2021-01-01', 1),
	('I', '2021-01-02', 2),
	('I', '2021-01-04', 3),
	('I', '2021-01-11', 5),
	('I', '2021-01-16', 9),
	('I', '2021-02-01', 4),
	('J', '2021-01-01', 6),
	('J', '2021-01-01', 5),
	('J', '2021-01-07', 7),
	('J', '2021-01-10', 6),
	('J', '2021-01-11', 8),
	('J', '2021-01-11', 9);

select * from Sales


DROP TABLE menu;

CREATE TABLE menu(
	product_id INTEGER,
	product_name VARCHAR(50),
	price INTEGER
);


INSERT INTO menu
	(product_id, product_name, price)
VALUES
	(1, 'sushi', 10),
	(2, 'curry', 15),
	(3, 'ramen', 12),
	(4, 'pizza', 14),
	(5, 'burger', 8),
	(6, 'pasta', 12),
	(7, 'salad', 7),
	(8, 'steak', 20),
	(9, 'chicken', 9),
	(10, 'sandwich', 6),
	(11, 'soup', 5),
	(12, 'taco', 8);
	
select * from menu;


CREATE TABLE members(
	customer_id VARCHAR(1),
	join_date DATE
);


INSERT INTO members
    (customer_id, join_date)
VALUES
    ('A', '2021-01-07'),
    ('B', '2021-01-09'),
    ('C', '2021-01-15'),
    ('D', '2021-02-02'),
    ('E', '2021-02-05'),
    ('F', '2021-02-15'),
    ('G', '2021-03-01');
	
	
SELECT* FROM members;


-- Lets find out how much each cutomer spent in my shop
  -- the customer id and price column
Select s.customer_id,SUM(m.price)  AS Total_spent
from sales s
join menu m
on s.product_id=m.product_id
group by s.customer_id
ORDER BY Total_spent DESC;

-- how many days has each customer visited my restaurant
 -- most loyal customer
select s.customer_id,count(distinct s.order_date) as days_visited
from sales s
group by customer_id
ORDER BY days_visited DESC;


--what was the first item purcahed by each customer
 -- we will first calculate the first purchase date of each customer
 -- we  will create a tenporary table CTE
with first_good_purchased as ( 

select  customer_id,min(s.order_date) as first_purchase
from sales s
group by s.customer_id
)
select fp.customer_id,fp.first_purchase,m.product_name
from first_good_purchased fp
join sales s on  s.customer_id= fp.customer_id
and fp.first_purchase= s.order_date
join menu m on m.product_id =s.product_id


-- The most purchaes item on the menu and how many times it was purchased
select m.product_name,count(*) as total_purchased
from sales s
join menu m on s.product_id=m.product_id
group by m.product_name
order by total_purchased DESC
LIMIT 3;

-- which item was purchased the most by each customer
with customer_popularity  as(
select s.customer_id,m.product_name,count(*) as purchase_count,
dense_rank ()over (partition by s.customer_id order by count(*) desc) as rank from sales s
join menu m  on s.product_id =m.product_id
group by s.customer_id,m.product_name

)
select cp.customer_id,cp.product_name,cp.purchase_count
from customer_popularity cp
where rank=1


