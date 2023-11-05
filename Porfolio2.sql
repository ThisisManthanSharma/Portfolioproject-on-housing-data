Select * 
From nashvillehousing

--Date formatting

Select Saledate, Cast(Saledate as Date)
From NashvilleHousing

Update NashvilleHousing
Set Saledate = Cast(SaleDate as date)

-- if above don't work, then

Alter table nashvillehousing
Add Saledateconverted Date;

Update NashvilleHousing
Set Saledateconverted = Cast(Saledate as Date)

Select Saledateconverted
From NashvilleHousing

-- NUll Address

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.propertyAddress, b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Fill the null values

Update a
Set propertyaddress = Isnull(a.propertyAddress, b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into individual form

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From NashvilleHousing

--Breaking address using Parse

Select owneraddress
From NashvilleHousing
Where OwnerAddress is not null

Select 
Parsename(Replace(OwnerAddress, ',', '.'), 3),
Parsename(Replace(OwnerAddress, ',', '.'), 2),
Parsename(Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing
Where owneraddress is not null

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select OwnerSplitCity,  OwnerSplitState, OwnerSplitAddress
From PortfolioProject.dbo.NashvilleHousing
Order by OwnerSplitAddress desc

--Change Y and N to YES and No 

Select Distinct(Soldasvacant), Count(Soldasvacant) as counts
From NashvilleHousing
Group by SoldAsVacant
Order by 2

Select Soldasvacant
, Case When Soldasvacant = 'N' then 'NO'
When Soldasvacant = 'Y' then 'YES'
Else Soldasvacant
End
From nashvillehousing

Update NashvilleHousing
Set SoldAsVacant = Case When Soldasvacant = 'N' then 'NO'
When Soldasvacant = 'Y' then 'YES'
Else Soldasvacant
End


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) as row_num
From NashvilleHousing
)
Select *
From RowNumCTE
Where row_num >1
Order by PropertyAddress

-- Delete Unused Columns



Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate