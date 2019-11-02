### CONNECTION TO SQL SERVER ###

# Load ODBC package
library(RODBC)

# Create connection
connection <- odbcDriverConnect('driver={SQL Server};server=BIPROD;database=JBC_BI_Sandbox;trusted_connection=true')

# Create query
query <- paste("select top 100 * from JBC_BI_Sandbox.dbo.FOLDER_SELECTIE;")

# Import data into dataframe
table <- sqlQuery(connection, query)

# Show structure of data
str(table)

# Close connection
odbcClose(connection)