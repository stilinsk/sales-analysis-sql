# sales-analysis-sql


### Project overview
This is a case study where we have a project form scratch ,we will take it from (simon)hypothetical owner of  a supermarket where we will create data using three tables and merge the tables where we have a shop where the owner wants to make sense of data while understanding which products have a better purchasing power and  insights in relations to our customers  
We have  to first create a database named `shop`

We will then create our three tables 
the first one is  ` sales table`  where we have the following columns     (customer_id, order_date, product_id)
The second table is the `menu table ` it has the following columns        (product_id, product_name, price)
  the last table is the  `memebrs table`  which has the follwing columns  (customer_id, join_date)

We will  be using POSTGRESQL for this project
### Analysis 
We will first look at our most valuable customer (this comes in handy when we want to reward our mostvalues customers with offers

In the follwing query we will be finding ourt the amount that each customer spends in the shop


```
Select s.customer_id,SUM(m.price)  AS Total_spent
from sales s
join menu m
on s.product_id=m.product_id
group by s.customer_id
ORDER BY Total_spent DESC;
```

![SA (2)](https://github.com/stilinsk/sales-analysis-sql/assets/113185012/0b03aa11-6a2e-4e6f-88b2-85b6e49079e3)

We will also look  at how many days each  customer visited the shop 
```
select s.customer_id,count(distinct s.order_date) as days_visited
from sales s
group by customer_id
ORDER BY days_visited DESC;
```
![SB (2)](https://github.com/stilinsk/sales-analysis-sql/assets/113185012/77b88dfe-d5fc-422c-bc66-51762ed026fc)


  we can thus compare whether does visiting the shop more means spending  more on the shop

As we can clearly see visting the shop more frequntly does not mean that the buyer is spendng more 

  In the following third query we will be looking at the items that was purchased by each customer first in our shop   in this regard we will be implenmenting a a CTE  to look into this i will also explaimn breiefly  what the code does
  ```
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
```
![SC](https://github.com/stilinsk/sales-analysis-sql/assets/113185012/43a70128-e253-4def-83a0-32fca408ea09)


he query creates a Common Table Expression (CTE) named first_good_purchased. This CTE is used to find the first purchase date for each customer by selecting the minimum (earliest) order_date for each customer_id from the sales table. It groups the data by customer_id.

The main query selects data from the first_good_purchased CTE. It retrieves the customer_id, first_purchase, and product_name columns.

It performs two joins to get the desired output:

It joins the first_good_purchased CTE with the sales table on the customer_id and first_purchase date to identify the first purchase for each customer.
It joins the result of the first join with the menu table on the product_id from the sales table to get the name of the product that was first purchased by each customer.


In the following code  we will be looking for 3 most purchased goods in our shop
```
select m.product_name,count(*) as total_purchased
from sales s
join menu m on s.product_id=m.product_id
group by m.product_name
order by total_purchased DESC
LIMIT 3;
```
![SA](https://github.com/stilinsk/sales-analysis-sql/assets/113185012/22426d4a-e822-4c9f-9571-61dd0aee20fe)



in the following last query we will be lookinng at the item that was purchased most by each customer and for that we will definitely have to make a CTE 
```
with customer_popularity  as(
select s.customer_id,m.product_name,count(*) as purchase_count,
dense_rank ()over (partition by s.customer_id order by count(*) desc) as rank from sales s
join menu m  on s.product_id =m.product_id
group by s.customer_id,m.product_name

)
select cp.customer_id,cp.product_name,cp.purchase_count
from customer_popularity cp
where rank=1
```
![SB](https://github.com/stilinsk/sales-analysis-sql/assets/113185012/4ae9be52-d841-43ab-aa69-ba7f3aeba743)

The query creates a Common Table Expression (CTE) named customer_popularity. This CTE calculates the popularity of products for each customer by counting the number of times each product was purchased by a customer and assigning a rank to each product based on its purchase count. It uses a window function dense_rank() to determine the rank of products within each customer's purchases.

The main query selects data from the customer_popularity CTE. It retrieves the customer_id, product_name, and purchase_count columns for products with the highest popularity rank (rank=1). This means it returns the most popular product for each customer.

