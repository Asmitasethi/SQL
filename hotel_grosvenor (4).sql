create table grosvenor;
use grosvenor;

create table hotel
(
hotel_no char(4) NOT NULL,
hotel_name varchar (20) NOT NULL,
hotel_address varchar (50) NOT NULL,
PRIMARY KEY (hotel_no)
);

create table room
(
room_no char(4)NOT NULL,
type char (1) NOT NULL,
price decimal (5,2) NOT NULL,
dates Date,
primary key(room_no),
primary key(hotel_no)
);
create table booking
(
guest_no char(4) NOT NULL,
date_From datetime NOT NULL,
date_To datetime null,
Primary key (hotel_no),
Primary key (room_no)
);

create table guest
(
guest_name varchar(20) NOT NULL,
guest_address varchar(50) NOT NULL,
PRIMARY KEY (guest_no) 
);


Insert into hotel (hotel_no, hotel_name, hotel_address)
values 
('H111','Grosvenor Hotel','London'),
('H123','Grosvenor Hotel','London'),
('H156','Grosvenor Hotel','London'),
('H117','Westin','Australia'),
('H711','Trident Hotel','India');

insert into room (Room_No, Hotel_No, Type, Price)
values
('1', 'H111', 'D', 38.00),
('2', 'H111', 'D', 86.00),
('3', 'H111', 'F', 40.00),
('4', 'H111', 'F', 98.00)
;


insert into guest (Guest_No, Name, Address)
 VALUES 
 ('G111','John Smith','London'),
 ('G112','malcom','Canada'),
 ('G113','anil','Australia'),
 ('G114','vaibhav','China')
 ;

UPDATE room SET price = price*1.05;

create table  booking_old
(
hotel_No char(4) Not Null,
guest_No char(4) not null,
date_From datetime not null,
date_To datetime not null,
room_No varchar(4) not null
);


insert into booking_old
(select * from Booking
Where date_To < date'2000-01-01');

delete from booking
where date_To < date (2000-01-01);

#Simple Queries

#1. List full details of all hotels.

select * from hotel;

#2. List full details of all hotels in London
select * from hotel 
where city = 'London';

#4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
select * from room where price < 40 AND type IN ('D','F')
order by price;

#5. List the bookings for which no date_to has been specified.
select* from booking where date_To is NULL;

#Aggregate Functions

#1.How many hotels are there?
select count(*) from hotel;

#2.What is the average price of a room?

select avg(price) from room;

#3. What is the total revenue per night from all double rooms?
select sum(price) from room where type = 'D';

#4. How many different guests have made bookings for August?
select count(distinct guest_no) from booking
where (date_From <= date'2000-08-01' and date_To >= date'2000-08-01') OR
(date_From >= date'2000-08-01' and date_From <= date '2000-08-31');

#Subqueries and Joins
#1. List the price and type of all rooms at the Grosvenor Hotel.

select price,type From Room
where hotel_no = (select hotel_no from hotel where hotel_name = 'Grosvenor Hotel') ;

#2. List all guests currently staying at the Grosvenor Hotel.

select * from guest 
where guest_no = (select guest_no from booking where date_From <= current_date()
and date_To >= current_date()and hotel_no = (select hotel_no From hotel 
where hotel_name = 'Grosvenor Hotel'));

#3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in theroom, if the room is occupied.

SELECT r.* FROM Room r LEFT JOIN 
(SELECT g.guest_name, h.hotel_no, b.room_no FROM Guest g, booking b, hotel h
WHERE g.guest_no = b.guestNo AND b.hotelNo = h.hotelNo AND
hotel_name = 'Grosvenor Hotel' AND 
date_From <= CURRENT_DATE AND 
date_To >= CURRENT_DATE) AS XXX
ON r.hotel_no = XXX.hotel_no AND r.room_no = XXX.room_no;

#4. What is the total income from bookings for the Grosvenor Hotel today?

SELECT SUM(price) FROM Booking b, Room r, Hotel h
WHERE (date_From <= CURRENT_DATE AND 
date_To >= CURRENT_DATE) AND
r.hotel_no = h.hotel_no AND r.room_no = b.room_no AND 
hotel_name = 'Grosvenor Hotel';

#5. List the rooms that are currently unoccupied at the Grosvenor Hotel.
SELECT * FROM Room r
WHERE room_no NOT IN 
(SELECT room_no FROM Booking b, Hotel h
WHERE (date_From <= CURRENT_DATE AND 
date_To >= CURRENT_DATE) AND 
b.hotel_no = h.hotel_no AND hotel_name = 'Grosvenor Hotel');

#6 What is the lost income from unoccupied rooms at the Grosvenor Hotel?

SELECT SUM(price) FROM room r
WHERE room_no NOT IN 
(SELECT room_no FROM booking b, hotel h
WHERE (date_From <= CURRENT_DATE AND 
date_To >= CURRENT_DATE) AND 
b.hotel_no = h.hotel_no AND hotel_name = 'Grosvenor Hotel');

# Grouping

#1. List the number of rooms in each hotel.
SELECT hotel_no, COUNT(room_no) AS count FROM room
GROUP BY hotel_no;

#2. List the number of rooms in each hotel in London.
SELECT hotel_no, COUNT(room_no) AS count FROM room r, hotel h
WHERE r.hotel_no = h.hotel_no AND city = 'London'
GROUP BY hotel_no;


#3. What is the average number of bookings for each hotel in August?
SELECT AVG(X) 
FROM ( SELECT hotel_no, COUNT(hotel_no) AS X
FROM Booking b
WHERE (date_From <= DATE’2000-08-01’ AND 
date_To >= DATE’2000-08-01’) OR
(date_From >= DATE’2000-08-01’ AND 
date_From <= DATE’2000-08-31’)
GROUP BY hotel_no);

#4. What is the most commonly booked room type for each hotel in London?
SELECT MAX(X)
FROM ( SELECT type, COUNT(type) AS X
FROM Booking b, Hotel h, Room r
WHERE r.roomNo = b.roomNo AND b.hotel_no = h.hotel_no AND
city = 'London'
GROUP BY type);

#5.What is the lost income from unoccupied rooms at each hotel today?

SELECT hotel_no, SUM(price) FROM Room r
WHERE room_no NOT IN 
(SELECT room_no FROM booking b, hotel h
WHERE (date_From <= CURRENT_DATE AND 
date_To >= CURRENT_DATE) AND 
b.hotel_no = h.hotel_no)
GROUP BY hotel_no;