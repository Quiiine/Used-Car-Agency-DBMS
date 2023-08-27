use Imperor;
ALTER TABLE main
ADD COLUMN id INT PRIMARY KEY AUTO_INCREMENT;



CREATE TABLE vehicle_information
AS SELECT 
	name, 
    fuel, 
    year, 
    seats, 
    km_driven, 
    id
FROM main;



CREATE TABLE vehicle_consumption
AS SELECT
	transmission, 
    engine, 
    max_power, 
    torque,
    id
FROM main;



CREATE TABLE vehicle_patern
AS SELECT
	Dealer, 
    owner, 
    seller_type, 
    selling_price, 
    mileage, 
    id
FROM main;





ALTER TABLE 
	vehicle_information
RENAME COLUMN id TO information_id;
ALTER TABLE 
	vehicle_information
MODIFY COLUMN information_id INT PRIMARY KEY AUTO_INCREMENT;



ALTER TABLE 
	vehicle_consumption
    rename column id to consumption_id;
    ALTER TABLE 
	vehicle_consumption
MODIFY COLUMN consumption_id INT PRIMARY KEY AUTO_INCREMENT,
ADD COLUMN 
	information_id INT,
ADD FOREIGN KEY (information_id) REFERENCES vehicle_information(information_id) ON DELETE CASCADE;



ALTER TABLE 
	vehicle_patern
RENAME COLUMN id TO patern_id;
ALTER TABLE 
	vehicle_patern
MODIFY COLUMN patern_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
ADD COLUMN information_id INT,
ADD FOREIGN KEY (information_id) REFERENCES vehicle_information(information_id) ON DELETE CASCADE;

SELECT 
	name as "Most Sold Vehicle", 
    COUNT(name) AS Number_of_Cars
FROM 
	vehicle_information
GROUP BY 
	name
ORDER BY 
	Number_of_Cars DESC
LIMIT 1;

SELECT 
	dealer AS 'Dealer Name', 
    COUNT(*) AS Total_Sold_Numer_of_Vehicles,
    SUM(selling_price) AS 'Revenue'
FROM 
	vehicle_patern
WHERE 
	dealer <> ''
GROUP BY 
	dealer
ORDER BY 
	Total_Sold_Numer_of_Vehicles DESC
LIMIT 1;



SELECT 
	name AS 'Vehicle Model',  
    AVG(selling_price) AS 'Average Price'
FROM 
	vehicle_information cd
JOIN 
	vehicle_patern ce 
ON 
	cd.information_id = ce.patern_id
GROUP BY 
	name;

SELECT 
	name AS 'Vehicle Model', 
    year AS 'Year of Manufacture'
FROM vehicle_information
WHERE 
	year = (SELECT min(year) FROM vehicle_information)
UNION
SELECT 
	name AS 'Vehicle Model', 
    year AS 'Year of Manufacture'
FROM 
	vehicle_information
WHERE year = (SELECT MAX(year) FROM vehicle_information)
LIMIT 2;


SELECT 
	name AS 'Vehicle Model', 
    year AS 'Year of Manufacture', 
    km_driven AS 'Kilometer Driven',
    selling_price AS 'Selling Price'
FROM 
	vehicle_information cd
LEFT JOIN vehicle_patern ce
	ON cd.information_id=ce.patern_id
ORDER BY 
	selling_price, 
    km_driven
LIMIT 1;



SELECT 
	sum(selling_price) AS 'Total Revenue of Individual'
FROM 
	vehicle_patern
WHERE 
	seller_type = "Individual";

(SELECT 
	dealer as 'Dealer', 
    name as 'Vehicle Model', 
    COUNT(name) Soled_Vehicles
FROM vehicle_information cd
JOIN vehicle_patern ce
	On cd.information_id = ce.patern_id
WHERE  dealer = 'Anny'
GROUP BY name
ORDER BY Soled_Vehicles desc
LIMIT 1)
UNION
(SELECT 
	dealer as 'Dealer', 
    name as 'Vehicle Model', 
    COUNT(name) as Soled_Vehicles
FROM vehicle_information cd
JOIN vehicle_patern ce
	On cd.information_id = ce.patern_id
WHERE  dealer = 'David'
GROUP BY name
ORDER BY Soled_Vehicles desc
LIMIT 1)
UNION
(SELECT 
	dealer as 'Dealer', 
	name as 'Vehicle Model', 
    COUNT(name) as Soled_Vehicles
FROM vehicle_information cd
JOIN vehicle_patern ce
	On cd.information_id = ce.patern_id
WHERE  dealer = 'Henry'
GROUP BY name
ORDER BY Soled_Vehicles desc
LIMIT 1)
ORDER BY Soled_Vehicles desc;

