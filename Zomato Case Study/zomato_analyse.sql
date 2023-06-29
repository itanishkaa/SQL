# 1.what is total amount each customer spent on zomato ?
select s.userid, sum(p.price) as Total_Amount 
from sales s
inner join
product p
on s.product_id=p.product_id 
group by s.userid;

# 2.How many days has each customer visited zomato?
select s.userid, 
count(distinct s.created_date) as Total_Days
from sales s
group by s.userid;

# 3.what was the first product purchased by each customer?
select * 
from 
(
select *,
dense_rank() over (partition by userid order by created_date)
RN
from sales
) T
where RN = 1;

# 4.what is most purchased item on menu & how many times was 
# it purchased by all customers ?
select userid, count(product_id) as cnt_product
from 
sales 
where 
product_id=(select product_id from sales 
	group by product_id order by count(product_id) 
    desc limit 1)
group by userid;

# 5.which item was most popular for each customer?
with cte as (
	select userid, product_id, count(product_id) 
    over (partition by userid, product_id) as cnt
    from sales), cte1 as (
		select *, row_number() over (partition by userid 
        order by cnt desc) as rn1
        from cte)
select * from cte1 where rn1=1;

# 6.which item was purchased first by customer 
# after they become a member ?
with cte as (
	select u.userid, u.signup_date, s.product_id, 
    s.created_date from sales s 
    inner join users u
    on s.userid = u.userid
    and s.created_date>=u.signup_date
    )
select * from (
select *, row_number() over (partition by userid order by 
created_date) rn from cte ) T where rn=1;