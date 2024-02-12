-- Cleaning data 

Select * 
from portfolioproj2.dbo.NashvilleHousing

-- Setting and updating the date format

select SaleDate, Convert(Date, SaleDate) as TrueSaleDate
FRom portfolioproj2.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date, SaleDate)

Alter Table NashvilleHousing
Add ConvertedSaleDate Date;

Update NashvilleHousing
SET ConvertedSaleDate = Convert(Date, SaleDate)

-- lets see if that worked 

Select ConvertedSaleDate 
From portfolioproj2.dbo.NashvilleHousing

Select * 
From portfolioproj2.dbo.NashvilleHousing

-- populate Property Address data

Select *
From portfolioproj2.dbo.NashvilleHousing
--Where PropertyAddress is null 
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FRom portfolioproj2.dbo.NashvilleHousing a
join portfolioproj2.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is Null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FRom portfolioproj2.dbo.NashvilleHousing a
join portfolioproj2.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is Null

Select PropertyAddress, uniqueID, ParcelID
From portfolioproj2.dbo.NashvilleHousing

-- Splitting the City and Address in the Property Address

Select PropertyAddress
From portfolioproj2.dbo.NashvilleHousing

Select PropertyAddress,
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2),
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)
From portfolioproj2.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET propertySplitAddress = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add propertySplitCity nvarchar(255);

Update NashvilleHousing
SET propertySplitCity = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)

Select * 
FRom portfolioproj2.dbo.NashvilleHousing

-- Splitting the Owner Address




Select OwnerAddress
From portfolioproj2.dbo.NashvilleHousing

select 
parsename(Replace(OwnerAddress, ',', '.'), 3),
parsename(Replace(OwnerAddress, ',', '.'), 2),
parsename(Replace(OwnerAddress, ',', '.'), 1)
FRom portfolioproj2.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = parsename(Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = parsename(Replace(OwnerAddress, ',', '.'), 2)

ALter TAble NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = parsename(REPLACE(OwnerAddress, ',', '.'), 1)

Select * 
FRom portfolioproj2.dbo.NashvilleHousing

-- Replacing Y and N with Yes and No

select SoldAsVacant
From portfolioproj2.dbo.NashvilleHousing

select distinct(SoldAsVacant), count(SoldAsVacant)
FRom portfolioproj2.dbo.NashvilleHousing
group by SoldAsVacant
Order by 2

Select SoldAsVacant,
	CASE when SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
From Portfolioproj2.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = 	CASE when SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END

-- Remove Duplicates and Delete Unused Columns
-- not recommended to delete data in the database

--Select * ,
--Row_number() Over (
--	Partition by parcelID,
--			PropertyAddress,
--			SaleDate,
--			SalePrice, 
--			LegalReference 
--			Order by 
--			UniqueID ) row_num
			
--From portfolioproj2.dbo.NashvilleHousing
-- Always RUN the CTE Query with the Select statement

With RowNumCTE AS (
Select * ,
Row_number() Over (
	Partition by ParcelID,
			PropertyAddress,
			SaleDate,
			SalePrice, 
			LegalReference 
			Order by 
			UniqueID
			) row_num

FRom portfolioproj2.dbo.NashvilleHousing
			)
Select *
From RowNumCTE
where row_num > 1

Select *
From Portfolioproj2.dbo.NashvilleHousing

Alter Table Portfolioproj2.dbo.NashvilleHousing
Drop COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict