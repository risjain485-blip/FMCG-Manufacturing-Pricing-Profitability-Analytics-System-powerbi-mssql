CREATE OR ALTER VIEW dbo.VW_FMCG_MANUFACTURING_PRICING_ANALYTICS_NEW
AS
WITH FMCGCAL AS (
    SELECT
        FPM.UnitID,
        DMU.ManufacturingUnitName,
        FPM.State_Code,
        DM.State,
        FPM.MaterialCategoryID,
        DMC.MaterialCategory,
        FPM.Cat_Code,
        DC.Category,
        FPM.Sub_Category_ID,
        DS.SubCategory,
        FPM.Main_Prod_Cat_ID,
        FPM.Plant_Manager_ID,
        DPM.PlantManager,
        FPM.Product_ID,
        DPP.ProductPack,

        FPM.ProductionCapacityQuintalbyDay,
        FPM.ProducedCapacityQuintalbyDay,
        FPM.ExpectedProductionQuintalbyDay,
        FPM.ManufacturedDate,

        FPM.BrandFamily_ID,
        FPM.PackSize,
        FPM.Year,
        FPM.ManufacturedMonth,
        FPM.PlantWorkingHours,
        FPM.PlantCost AS PlantCostPerDay,
        FPM.MaintenanceCostbyday,

        CAST(
            LEFT(FPM.PackSize, PATINDEX('%[^0-9]%', FPM.PackSize + 'X') - 1)
            AS INT
        ) AS PackValue,

        UPPER(
            LTRIM(RTRIM(
                SUBSTRING(
                    FPM.PackSize,
                    PATINDEX('%[^0-9]%', FPM.PackSize),
                    LEN(FPM.PackSize)
                )
            ))
        ) AS PackUnit,

        (FPM.PlantCost + FPM.MaintenanceCostbyday) AS TotalOperationalCost

    FROM dbo.FACT_PRD_MANU_PROD_MASTER_MAIN_NEW_DATA FPM
    LEFT JOIN dbo.DM_Manufacturing_Unit DMU ON FPM.UnitID = DMU.UnitID
    LEFT JOIN dbo.DM_State DM ON FPM.State_Code = DM.State_Code
    LEFT JOIN dbo.DM_Material_Category DMC ON FPM.MaterialCategoryID = DMC.MaterialCategoryID
    LEFT JOIN dbo.DM_Category DC ON FPM.Cat_Code = DC.Cat_Code
    LEFT JOIN dbo.DM_Subcategory DS ON FPM.Sub_Category_ID = DS.Sub_Category_ID
    LEFT JOIN dbo.DM_Plant_Manager DPM ON FPM.Plant_Manager_ID = DPM.ID
    LEFT JOIN dbo.DM_Product_Pack DPP ON FPM.Product_ID = DPP.ProductID
),

ProdCalc AS (
    SELECT
        FM.*,

        /* UNIT-AWARE PACKS PER QUINTAL */
        CASE
            WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
            WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
            ELSE NULL
        END AS PacksPerQuintal,

        /* TOTAL RETAIL PACKS (Produced/Production/Expected) */
        FM.ProducedCapacityQuintalbyDay *
        CASE
            WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
            WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
            ELSE NULL
        END AS TotalRetailPacksProduced,

        FM.ProductionCapacityQuintalbyDay *
        CASE
            WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
            WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
            ELSE NULL
        END AS TotalRetailPacksProduction,

        FM.ExpectedProductionQuintalbyDay *
        CASE
            WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
            WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
            ELSE NULL
        END AS TotalRetailPacksTarget,

        /* BASE COSTS PER PACK (DECIMAL SAFE) */
        FM.TotalOperationalCost * 1.0
        / NULLIF(
            FM.ProducedCapacityQuintalbyDay *
            CASE
                WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
                WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
                ELSE NULL
            END, 0
        ) AS ProducedBaseCostPerPack,

        FM.TotalOperationalCost * 1.0
        / NULLIF(
            FM.ProductionCapacityQuintalbyDay *
            CASE
                WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
                WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
                ELSE NULL
            END, 0
        ) AS ProductionBaseCostPerPack,

        ROUND(
            FM.TotalOperationalCost * 1.0
            / NULLIF(
                FM.ExpectedProductionQuintalbyDay *
                CASE
                    WHEN FM.PackUnit IN ('G', 'ML') THEN 100000.0 / NULLIF(FM.PackValue, 0)
                    WHEN FM.PackUnit IN ('KG', 'L')  THEN 100.0    / NULLIF(FM.PackValue, 0)
                    ELSE NULL
                END, 0
            ), 2
        ) AS TargetBaseCostPerPack

    FROM FMCGCAL FM
),

UtilCalc AS (
    SELECT
        PC.*,

        ROUND(
            PC.ProducedCapacityQuintalbyDay * 100.0
            / NULLIF(PC.ProductionCapacityQuintalbyDay, 0), 3
        ) AS CapacityUtilizationPct,

        CASE
            WHEN PC.ProducedCapacityQuintalbyDay * 100.0
                 / NULLIF(PC.ProductionCapacityQuintalbyDay, 0) = 100
                THEN '100% Utilization'
            WHEN PC.ProducedCapacityQuintalbyDay * 100.0
                 / NULLIF(PC.ProductionCapacityQuintalbyDay, 0) >= 80
                THEN 'Optimal'
            WHEN PC.ProducedCapacityQuintalbyDay * 100.0
                 / NULLIF(PC.ProductionCapacityQuintalbyDay, 0) < 80
                THEN 'Under Utilization'
            ELSE 'Utilized'
        END AS CapacityUtilizationStatus,

        ROUND(
            (PC.ProducedCapacityQuintalbyDay - PC.ExpectedProductionQuintalbyDay) * 100.0
            / NULLIF(PC.ExpectedProductionQuintalbyDay, 0), 2
        ) AS TargetProductionVarianceCapacity,

        PC.ProductionCapacityQuintalbyDay - PC.ProducedCapacityQuintalbyDay
            AS LostCapacityPerQuintal,

        ROUND(
            (PC.ProducedCapacityQuintalbyDay - PC.ProductionCapacityQuintalbyDay) * 100.0
            / NULLIF(PC.ProductionCapacityQuintalbyDay, 0), 2
        ) AS ProductionVarianceCapacity,

        AVG(PC.ProducedCapacityQuintalbyDay)
        OVER (
            PARTITION BY YEAR(PC.ManufacturedDate),
                         MONTH(PC.ManufacturedDate)
        ) AS AvgMonthlyProduction
    FROM ProdCalc PC
),

MarginCalc AS (
    SELECT
        UC.*,

        CASE
            WHEN UC.Category = 'Beverages' THEN 'Beverages'
            WHEN UC.Category IN ('Snacks','Breakfast','Biscuits') THEN 'Food'
            ELSE 'Others'
        END AS MainProductCategory,

        CASE
            WHEN UC.Category = 'Beverages' THEN 0.25
            WHEN UC.Category IN ('Snacks','Breakfast','Biscuits') THEN 0.220
            ELSE 0
        END AS ManufacturerMarginPct,

        CASE
            WHEN UC.Category IN ('Beverages','Snacks') THEN 0.110
            WHEN UC.Category = 'Biscuits' THEN 0.075
            WHEN UC.Category = 'Breakfast' THEN 0.095
            ELSE 0
        END AS DistributorMarginPct,

        CASE
            WHEN UC.Category = 'Beverages' THEN 0.210
            WHEN UC.Category = 'Snacks' THEN 0.222
            WHEN UC.Category = 'Biscuits' THEN 0.188
            WHEN UC.Category = 'Breakfast' THEN 0.158
            ELSE 0
        END AS RetailerMarginPct
    FROM UtilCalc UC
),

PriceCalc AS (
    SELECT
        MC.*,

        /* PRODUCED */
        MC.ProducedBaseCostPerPack * (1 + MC.ManufacturerMarginPct) AS ExFactoryPrice_Produced,

        ROUND(MC.ProducedBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct), 2)
            AS WholesalePrice_Produced,

        ROUND(MC.ProducedBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct) * (1 + MC.RetailerMarginPct), 3)
            AS PreTaxMRP_Produced,

        /* PRODUCTION */
        MC.ProductionBaseCostPerPack * (1 + MC.ManufacturerMarginPct) AS ExFactoryPrice_Production,

        ROUND(MC.ProductionBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct), 2)
            AS WholesalePrice_Production,

        MC.ProductionBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct) * (1 + MC.RetailerMarginPct)
            AS PreTaxMRP_Production,

        /* EXPECTED */
        MC.TargetBaseCostPerPack * (1 + MC.ManufacturerMarginPct) AS ExFactoryPrice_Expected,

        ROUND(MC.TargetBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct), 2)
            AS WholesalePrice_Expected,

        ROUND(MC.TargetBaseCostPerPack * (1 + MC.ManufacturerMarginPct) * (1 + MC.DistributorMarginPct) * (1 + MC.RetailerMarginPct), 2)
            AS PreTaxMRP_Expected,

        /* TAX */
        CASE
            WHEN MC.Year >= 2017 AND MC.Category = 'Beverages' THEN 0.18
            WHEN MC.Year >= 2017 AND MC.Category IN ('Snacks','Biscuits','Breakfast') THEN 0.12
            WHEN MC.Year < 2017 AND MC.Category = 'Beverages' THEN 0.125
            WHEN MC.Year < 2017 AND MC.Category IN ('Snacks','Biscuits','Breakfast') THEN 0.05
            ELSE 0
        END AS TaxPct
    FROM MarginCalc MC
)

SELECT
    PC.*,

    ROUND(PC.PreTaxMRP_Produced   * (1 + PC.TaxPct), 2) AS MRP_Produced,
    ROUND(PC.PreTaxMRP_Produced   * (1 + PC.TaxPct), 2) - PC.ProducedBaseCostPerPack   AS ProfitPerPack_Produced,

    ROUND(PC.PreTaxMRP_Production * (1 + PC.TaxPct), 2) AS MRP_Production,
    ROUND(PC.PreTaxMRP_Production * (1 + PC.TaxPct) - PC.ProductionBaseCostPerPack, 2) AS ProfitPerPack_Production,

    ROUND(PC.PreTaxMRP_Expected   * (1 + PC.TaxPct), 2) AS MRP_Expected,
    ROUND(PC.PreTaxMRP_Expected   * (1 + PC.TaxPct), 2) - PC.TargetBaseCostPerPack     AS ProfitPerPack_Expected

FROM PriceCalc PC;
GO


