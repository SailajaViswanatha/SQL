create database Bank;
use bank;

## 1. What is the demographic profile of the bank clients and how does it vary across districts?

## Data Cleaning

select * from client;
create table client_new as 
select client_id, birth_number, mid(birth_number,3,2) as month, district_id
from client;
select * from client_new;
create table new_client as
select client_id, birth_number, month, 
case
when month>50 then 'Female'
else 'Male'
end as 'Gender',
district_id
from client_new;

select * from new_client;

select * from district;
create table new_district as 
select a1 as district_id,a2 as district_name,a3 as region,a4 as no_of_inhabitants,
a5 as no_of_MI_lessthan_499, a6 as no_of_MI_between_500to1999,
a7 as no_of_MI_between_2000to9999,
a8 as no_of_MI_greaterthan_10000,a9 as no_of_cities,a10 as ratio_of_UI,
a11 as Average_salary,a12 as unemployement_rate_95,
a13 as unemployement_rate_96,
a14 as no_of_entrepreneurs,a15 as no_of_crimes_95,
a16 as no_of_crimes_96
from district;

select * from new_district;

## Data Analysis

select Gender,count(gender) as 'Gender Count' from new_client
group by gender
order by count(gender) desc; 

## Male clients(2724) are more in number when compared to Female clients(2645)

select district_name,gender,count(gender) as 'Gender count' from  new_district,new_client
where new_district.district_id=new_client.district_id
group by district_name,gender
order by count(gender) desc;

## Conclusion
## The district Hl.m.Praha has maximum number of male clients (339) and district Ceske Budejovice has minimum no of male clients (18)
## The district Hl.m.Praha has maximum number of female clients (324) and district  Pribrom has minimum no of female clients (19)

# 2. How the banks have performed over the years?Give their detailed analysis year and month wise.

#Data Cleaning

create table trans_new as
select trans_id,account_id,date,left(date,2) as Year,mid(date,3,2) as Month,type as Transaction_type,
operation  as Mode_of_transaction,amount,balance,k_symbol,bank,account 
from trans;

select * from trans_new;

# Data analysis
select year,month,transaction_type, mode_of_transaction,k_symbol,sum(amount) as Total_amount
from trans_new
group by year,month,transaction_type,mode_of_transaction,k_symbol
order by year,month,sum(amount) desc;

## From the year 93 to 98 most of the amount is credited in cash

## 3.. What are the most common types of accounts and how do they differ in terms of usage and profitability?
# Data Cleaning

select * from trans;

create table new_trans as
select trans_id,account_id,date,type,operation,amount,balance,k_symbol,bank,account,
case
when account regexp '^[0-9]' then 'Combined account'
else 'Single account'
end as account_type
from trans;

select * from new_trans;

## Data Analysis
select account_type,count(account_id) as 'Count of clients',sum(amount) as 'Total amount'
from new_trans
group by account_type; 

## The count of clients who are using single accounts(760931) is more than clients using combined account(295389)

select account_type,k_symbol, count(trans_id) as 'Total transactions',
sum(amount) as 'Total Profitable amount'
from new_trans
where k_symbol in ('POJISTNE','SLUZBY','UROK','UVER','SIPO')
group by account_type,k_symbol
order by sum(amount) desc; 

## More profits to the bank is obtaining through household of the clients having combined account 

# 4.Which type of cards are most frequently used by bank's clients and what is the overall profitability of credit card business?

select * from card;

## Data Analysis

select type as card_type,count(card_id) as 'Total count' from card
group by card_type
order by count(card_id) desc;

# The Classic card is most frequently used by the clients followed by Junior and Gold

select operation, sum(amount) as credit_card_profitability from trans
where operation in ('VYBER')
GROUP BY operation;

## The overall profitability from credit card usage is 2339570649

## 5. What are the major expenses of the bank and how can they be reduced to improve profitability?

select * from orders_new;

select k_symbol,sum(amount) as Total_amount 
from orders_new
where k_symbol in ('LEASING')
group by k_symbol;

# The expenses of the bank can be reduced throug leasing



## 6. What is the bank's loan portfolio and how how does it vary across different purposes and client segments?

## Data Cleaning

select * from loan;

create table new_loan as
select loan_id,account_id,date,left(date,2) as Year,mid(date,3,2) as Month,amount,
duration,payments,status from loan;

select * from new_loan;

## Data Analysis

select year,status,count(account_id) as no_of_clients,sum(amount) as 'Total Amount' from new_loan
group by year,status
order by year, sum(amount) desc;

## In the year 93  the cleared loan amount of clients with status A (contract finished and cleared loan), is more
## In the year 94  the cleared loan amount of clients with status A (contract finished and cleared loan), is more
## In the year 95  the cleared loan amount of clients with status C (running contract  and clearing loan), is more
## In the year 96  the cleared loan amount of clients with status C (running contract  and clearing loan), is more
## In the year 97  the cleared loan amount of clients with status C (running contract  and clearing loan), is more
## In the year 98  the cleared loan amount of clients with status C (running contract  and clearing loan), is more







