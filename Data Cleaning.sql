SELECT * FROM Nashville_housing_data order by [Sale Date]
--lets convert the sale date to a date format
SELECT [Sale Date],CONVERT(Date,[Sale Date]) FROM Nashville_housing_data 
UPDATE Nashville_housing_data set [Sale Date]=CONVERT(Date,[Sale Date]) --not working
SELECT * FROM Nashville_housing_data 
ALTER TABLE Nashville_housing_data add SalesDateConverted Date;
UPDATE Nashville_housing_data SET SalesDateConverted=CONVERT(Date,[Sale Date])

--Populate Property Address data (we need reference point to fill the values)
SELECT * from Nashville_housing_data 
--where [Property Address] is null 
order by [Parcel ID]
--where the Property Address is exact the Parcel ID is also exactly the same (44,45) so we will populate on that basis, and since we are comparing values within the same table so we need to perform a SELF JOIN (we used the UNNamed column to make sure that its not the same row)
SELECT a.[Parcel ID],a.[Property Address],b.[Parcel ID],b.[Property Address],ISNULL(a.[Property Address],b.[Property Address]) 
from Nashville_housing_data a 
join Nashville_housing_data b 
on a.[Parcel ID]=b.[Parcel ID] and a.[Unnamed: 0]<>b.[Unnamed: 0]
where a.[Property Address] is null

UPDATE a set [Property Address]=ISNULL(a.[Property Address],b.[Property Address]) 
from Nashville_housing_data a 
join Nashville_housing_data b 
on a.[Parcel ID]=b.[Parcel ID] and a.[Unnamed: 0]<>b.[Unnamed: 0]
where a.[Property Address] is null
DELETE FROM a 
from Nashville_housing_data a 
join Nashville_housing_data b 
on a.[Parcel ID]=b.[Parcel ID] and a.[Unnamed: 0]<>b.[Unnamed: 0]
WHERE a.[Property Address] is null
SELECT a.[Parcel ID],a.[Property Address],b.[Parcel ID],b.[Property Address]
from Nashville_housing_data a 
join Nashville_housing_data b 
on a.[Parcel ID]=b.[Parcel ID] and a.[Unnamed: 0]<>b.[Unnamed: 0]

----lets combine the address and city
--Alter table Nashville_housing_data add Full_address VARCHAR(50)
--UPDATE Nashville_housing_data set Full_address = CONCAT([Property Address],',',[Property City]) FROM Nashville_housing_data
--SELECT Full_Address FROM Nashville_housing_data
--SELECT SUBSTRING(Full_Address,1,CHARINDEX(',',Full_Address)-1) as Separate_Address,
--SUBSTRING(Full_Address,CHARINDEX(',',Full_Address)+1,LEN(Full_Address)) as Separate_Address FROM Nashville_housing_data   -- (-1) is there to to get the substring before the comma and +1 to get the substring after the comma
--(can be done using parsename,replace)
select * from Nashville_housing_data


--removing duplicates
WITH RowNumCTE as (select *,ROW_NUMBER() OVER(PARTITION BY [Parcel ID],[Property Address],[Sale Price],[Sale Date],[Legal Reference] order by [Unnamed: 0]) row_num
from Nashville_housing_data) 
--SELECT * FROM RowNumCTE where row_num>1
DELETE FROM RowNumCTE where row_num>1  --they are duplicates
--where row_num>1   we cant do this directly as it is in a windows function so we use CTE


--delete unused columns
 ALTER Table Nashville_housing_data drop column [Tax District],[image],[Building value],[Finished Area],[Exterior Wall],[Sale Date],[Acreahe],[Half Bath]
 select * from Nashville_housing_data