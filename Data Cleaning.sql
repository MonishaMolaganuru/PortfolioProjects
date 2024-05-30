--Data Cleaning 

select * from PortfolioProject.dbo.HousingData

--Standardize Date Format

select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.HousingData

update HousingData
set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE HousingData
add SaleDateConverted Date;

update HousingData
set SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.HousingData

--Populate Property Address Data

select *
from PortfolioProject.dbo.HousingData
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.HousingData a
join PortfolioProject.dbo.HousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.HousingData a
join PortfolioProject.dbo.HousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select PropertyAddress
from PortfolioProject.dbo.HousingData

--Breaking out Propertyaddress into Individual Columns (address, City, State)

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from PortfolioProject.dbo.HousingData

ALTER TABLE HousingData
add PropertySplitAddress Nvarchar(255);

update HousingData
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE HousingData
add PropertySplitCity Nvarchar(255);

update HousingData
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

select * from PortfolioProject.dbo.HousingData

--Breaking out Owneraddress into Individual Columns (address, City, State)

select OwnerAddress
from PortfolioProject.dbo.HousingData

select 
PARSENAME(replace(OwnerAddress, ',','.'), 3)
,PARSENAME(replace(OwnerAddress, ',','.'), 2)
,PARSENAME(replace(OwnerAddress, ',','.'), 1)
from PortfolioProject.dbo.HousingData

ALTER TABLE HousingData
add OwnerSplitAddress Nvarchar(255);

update HousingData
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)

ALTER TABLE HousingData
add OwnerSplitCity Nvarchar(255);

update HousingData
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'), 2)

ALTER TABLE HousingData
add OwnerSplitState Nvarchar(255);

update HousingData
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'), 1)

select * from PortfolioProject.dbo.HousingData

--Change Y and N to Yes and No in SoldasVacant Field

select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.HousingData
Group by SoldAsVacant
order by 2

select SoldAsVacant
,Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 End
from PortfolioProject.dbo.HousingData

update HousingData
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 End

select * from PortfolioProject.dbo.HousingData

--Remove Duplicates

with RowNumCTE as
(
Select *,
        Row_Number() over(
		partition by ParcelID, 
		             PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 order by
					    UniqueID
					    ) row_num
from PortfolioProject.dbo.HousingData
--order by ParcelID
)
Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

with RowNumCTE as
(
Select *,
        Row_Number() over(
		partition by ParcelID, 
		             PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 order by
					    UniqueID
					    ) row_num
from PortfolioProject.dbo.HousingData
--order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1
--order by PropertyAddress

--Delete Unused Columns

select * from PortfolioProject.dbo.HousingData

alter table PortfolioProject.dbo.HousingData
Drop column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict

























