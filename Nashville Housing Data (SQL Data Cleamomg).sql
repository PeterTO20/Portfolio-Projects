/*

Nashville Housing SQL Data Cleaning

Skills Used: SELF JOIN, CTE, Window Functions, Server Functions, UPDATE, ALTER

*/


SELECT 
	*
FROM [Nashville Housing Project]..Nashville_housing





---------------------------------------------------------------------------------------------------------------------

---- ### Standardize Data Format ### ----


-- Updated the data type for SaleDate column from DATETIME to DATE; Time won't serve purpose
SELECT 
	SaleDate, 
	CONVERT(date, SaleDate) AS saledate
FROM [Nashville Housing Project]..Nashville_housing


UPDATE Nashville_housing
SET saledate = CONVERT(DATE, saledate) -- Update didn't work



-- Update quert above didn't work properly. Tried another way.
ALTER TABLE Nashville_housing 
ADD sale_date_converted DATE; -- Adding new column for saledate with DATE data type


UPDATE Nashville_housing
SET sale_date_converted = CONVERT(DATE, SaleDate) -- Updated new column with data 





---------------------------------------------------------------------------------------------------------------------

---- ### Populate Property Address Data ### ----


-- There are NULLS in the PropertyAddress column and it could be populated if we had a reference point to base that off of; Used ParcelID.
SELECT 
	*
FROM [Nashville Housing Project]..Nashville_housing
--WHERE
--	PropertyAddress IS NULL
ORDER BY
	ParcelID -- Easier to spot duplicates for referencing



-- There are multiple ParcelIDs with the exact same address. And there are some ParcelIDs that are the same but one of them has a NULL address.
-- Used SELF JOIN to look at if a ParcelID is equal to a ParcelID then it'll have this address.
SELECT 
	a.ParcelID, 
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress) -- Replaces the NULLs with the address from the other table.
FROM [Nashville Housing Project]..Nashville_housing AS a
JOIN [Nashville Housing Project]..Nashville_housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] -- Where PacelID is the same but it's not the same row bc UniqueID is unique we want to populate the address.
WHERE a.PropertyAddress IS NULL


-- UPDATE PropertyAddress column
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Nashville Housing Project]..Nashville_housing AS a
JOIN [Nashville Housing Project]..Nashville_housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL





---------------------------------------------------------------------------------------------------------------------

---- ### Breaking Out Address into Individual Column (Address, City, State) ### ----


-- PropertyAddress column has the address and city together separated by a comma.
SELECT 
	PropertyAddress
FROM [Nashville Housing Project]..Nashville_housing


-- Used SUBSTRING and CHARINDEX to separate address and city.
SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM [Nashville Housing Project]..Nashville_housing


-- Added new column for the address.
ALTER TABLE Nashville_housing 
ADD property_address NVARCHAR(255)

-- Updated new column with the results.
UPDATE Nashville_housing
SET property_address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

-- Added new column for the city.
ALTER TABLE Nashville_housing 
ADD property_city NVARCHAR(255)

-- Updated new column with the results.
UPDATE Nashville_housing
SET property_city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

-- Check.
SELECT 
	*
FROM [Nashville Housing Project]..Nashville_housing




-- OwnerAddress column has the address, city, and state together separated by commas.
SELECT 
	OwnerAddress
FROM [Nashville Housing Project]..Nashville_housing


-- Used PARSENAME to separate address, city, and state.
-- Replaced commas with periods for PARSENAME to work.
SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Nashville Housing Project]..Nashville_housing


-- Added new column for the ownder address.
ALTER TABLE Nashville_housing 
ADD owner_address NVARCHAR(255);

-- Updated new column with the results.
UPDATE Nashville_housing
SET owner_address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

-- Added new column for the ownder city.
ALTER TABLE Nashville_housing 
ADD owner_city NVARCHAR(255);

-- Updated new column with the results.
UPDATE Nashville_housing
SET owner_city = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

-- Added new column for the ownder state.
ALTER TABLE Nashville_housing 
ADD owner_state NVARCHAR(255);

-- Updated new column with the results.
UPDATE Nashville_housing
SET owner_state = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Check.
SELECT 
	*
FROM [Nashville Housing Project]..Nashville_housing





---------------------------------------------------------------------------------------------------------------------

---- ### Change "Y" and "N" to "Yes" and "No" in SoldAsVacant Column ### ----


-- Check if it's only Yes, No, Y, N.
SELECT 
	DISTINCT SoldAsVacant
FROM [Nashville Housing Project]..Nashville_housing


-- Used CASE to change results.
SELECT 
	SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant -- If it's already Yes or No then leave it
		 END
FROM [Nashville Housing Project]..Nashville_housing

-- UPDATE column. 
UPDATE Nashville_housing
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END

-- Check.
SELECT 
	DISTINCT SoldAsVacant
FROM [Nashville Housing Project]..Nashville_housing





---------------------------------------------------------------------------------------------------------------------

---- ### Remove Duplicates ### ----


-- Original raw data is saved in separate database.
-- Used CTE and Window Functions to find where there are duplicate values. 
WITH RowNumCTE AS
(
SELECT 
	*,
	ROW_NUMBER() 
	OVER (
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
	ORDER BY UniqueID) AS row_num
FROM [Nashville Housing Project]..Nashville_housing
--ORDER BY 
--	ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num >1 -- Deletes duplicate rows

-- Check.
SELECT 
	*
FROM [Nashville Housing Project]..Nashville_housing





---------------------------------------------------------------------------------------------------------------------

---- ### Delete Unused Columns ### ----


-- Original raw data is saved in separate database.
SELECT *
FROM [Nashville Housing Project]..Nashville_housing

ALTER TABLE [Nashville Housing Project]..Nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
