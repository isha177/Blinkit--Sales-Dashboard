SELECT *
FROM blinkit_data;

-- Data Cleaning
SELECT * 
FROM blinkit_data;

SELECT COUNT(*) 
FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content =
    CASE
        WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_Fat_Content = 'reg' THEN 'Regular'
        ELSE Item_Fat_Content
    END;

SELECT DISTINCT(Item_Fat_Content)
FROM blinkit_data;



-- KPI Requirements
-- Total Sales (in Millions) for Outlet Establishment Year 20XX
SELECT CAST(SUM(Sales) / 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;



-- Average Sales for Outlet Establishment Year 20XX
SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;



-- Number of Items for Outlet Establishment Year 20XX
SELECT COUNT(*) AS No_Of_Items
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;



-- Average Rating for Outlet Establishment Year 20XX
SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022;


-- Granular Requirements
-- Total Sales by Item Fat Content
SELECT
    Item_Fat_Content,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;



-- Total Sales by Item Type 
SELECT 
    Item_Type, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022
GROUP BY Item_Type
ORDER BY Total_Sales DESC;



-- Fat Content by Outlet for Total Sales
SELECT
    Outlet_Location_Type,Item_Fat_Content,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
     CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
where Outlet_Establishment_Year = 2018
GROUP BY     Outlet_Location_Type , Item_Fat_Content
ORDER BY Total_Sales DESC;




-- better way
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;




-- total sales by outlet eastablishment 
SELECT
    Outlet_Establishment_Year,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
     CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
    CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY     Outlet_Establishment_Year
ORDER BY Total_Sales DESC;




-- Charts requiremnt
-- percenatge of sales by outlet size
SELECT 
    Outlet_Size, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;



-- Sales by Outlet Location
SELECT Outlet_Location_Type,
       CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC



-- All Metrics by Outlet Type
SELECT Outlet_Type, 
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC






