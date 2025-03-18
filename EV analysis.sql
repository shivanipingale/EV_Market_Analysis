create database electricvehicle;
select * from ev_market;


# create another table of clean data
create table ev
like ev_market;

# insert data into ev
insert into ev
select * from ev_market;
select * from ev;

# standardize data
select trim(Brand) from ev;
update ev set Brand = trim(Brand);

select trim(Model) from ev;
update ev set Model = trim(Model);

# check datatype
describe ev;
# change dattype
alter table ev modify column Brand varchar(10);
alter table ev modify column Model varchar(50);

# check for duplicate values
select *, row_number() over (partition by Brand, Model, AccelSec, TopSpeed_KmH, Range_Km, Efficiency_WhKm, FastCharge_KmH, 
RapidCharge, PowerTrain, PlugType, BodyStyle, Segment, Seats, PriceEuro) as row_num from ev;

select * from ev;
# Rename column name
alter table ev rename column MyUnknownColumn to Serial_No;

select Brand, count(Model) as Total_model from ev group by Brand order by Total_model desc; 

select distinct Segment from ev order by Segment;
alter table ev add column Segment_size char(10);
alter table ev modify column Segment_size varchar(50);

# Add car size column base on segment for proper analysis
Update ev set Segment_size = 
case 
when Segment = 'A' then 'Mini Car'
when Segment = 'b' then 'Small Car'
when Segment = 'C' then 'Compact Car'
when Segment = 'D' then 'Midsize Car'
when Segment = 'E' then 'Luxury Car'
when Segment = 'F' then 'Luxury-Fullsize'
when Segment = 'N' then 'Light Commercial'
else 'Sports Car'
end;

select distinct Segment, Segment_size from ev;
select * from ev;

update ev set Segment_size = 'Ultra Luxury' where Segment_size = 'Luxury';

select count(*) from ev;
select count(distinct(Model)) from ev;

select Brand, Model, Efficiency_WhKm, FastCharge_KmH from ev order by Efficiency_WhKm Asc, FastCharge_KmH Desc;

Alter table ev add column efficiency_level varchar(20);

# add column of efficient level
Update ev set efficiency_level =
case
When Efficiency_WhKm < 140 then 'very efficient'
When Efficiency_WhKm between 140 and 170 then 'efficient'
When Efficiency_WhKm between 170 and 200 then 'moderate'
When Efficiency_WhKm between 200 and 230 then 'less efficient'
When Efficiency_WhKm > 230 then 'energy intensive'
else null
end;

# check the efficiency level brand wise
select Brand, count(efficiency_level) as ef_level from ev where efficiency_level = 'efficient' 
group by Brand order by ef_level desc;
select Brand, avg(Efficiency_WhKm) from ev group by Brand;

select * from ev;

# Check the model with high speed, Range, price
select Brand, Model, PriceEuro, TopSpeed_KmH, Range_Km from ev order by PriceEuro desc, TopSpeed_KmH desc;

# check the model price according to seats
select Brand, Model, Seats, PriceEuro from ev order by PriceEuro desc;

select distinct PlugType from ev;

# check plugtype with Rapid charge
select Brand, RapidCharge, PlugType from ev order by Brand;

select PlugType, count(Model) from ev group by PlugType;


select * from ev where Brand = 'Tesla';

# check rank based on fast charging
select Brand, Model, FastCharge_KmH, Dense_Rank() over (order by FastCharge_KmH Desc) as Rank_FastCharge from ev;

# check for different factors
select Brand, Model, AccelSec from ev order by AccelSec;

select Brand, Model, FastCharge_KmH, Dense_Rank() over (order by FastCharge_KmH Desc) as Rank_FastCharge from ev;

select efficiency_level, count(Model) from ev Group by efficiency_level;

select Segment_size, count(Model) from ev Group by Segment_size;

#Check Total Price of each brand
select Brand, sum(PriceEuro) as Total_price from ev Group by Brand;

# check for model whose price more that avg price
select * from ev where PriceEuro > (select Avg(PriceEuro) from ev);

Select * from ev;




