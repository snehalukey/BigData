from datetime import datetime
import os
from pyspark.shell import sc
from pyspark.sql import SparkSession
import pyspark.sql.functions as F

if __name__ == '__main__':
    #Setting up spark
    spark = SparkSession.builder.appName("spark script").master('yarn').enableHiveSupport().getOrCreate()
    #Setting up spark context
    sc = spark.sparkContext
    log4jLogger = sc._jvm.org.apache.log4j
    # Get the logger for logging messages
    LOGGER = log4jLogger.LogManager.getLogger("json to csv")
    LOGGER.info("Starting spark script")

    # Path to the source directory containing JSON files
    file_path = "/home/talentum/zomato_etl_copy/source/"

    # List the JSON files in the specified directory
    file_path_loop = os.listdir(file_path+'json/')

    # Loop through each JSON file in the directory
    for idx, file_name in enumerate(sorted(file_path_loop)):

        # Create a CSV filename based on the current timestamp
        filename = "zomato_{}.csv".format(datetime.now().strftime('%Y%m%d%H%M%S'))
        LOGGER.info("Loading {}".format(file_name))

        # Read the JSON file into a DataFrame
        df = spark.read.format("json").load("file://{}json/{}".format(file_path, file_name))
        df.printSchema()

        # Explode the 'restaurants' array column into multiple rows
        new_df = df.select(F.explode(df.restaurants.restaurant))
        new_df.printSchema()
        LOGGER.info("Loaded {}".format(file_name))
        LOGGER.info("Transforming {}".format(file_name))

        # Perform transformations on the exploded DataFrame
        final_df = new_df.select(
            new_df.col.R.res_id.alias('Restaurant_ID'),
            new_df.col['name'].alias('Restaurant_Name'),
            new_df.col.location.country_id.alias('Country_Code'),
            new_df.col.location.city.alias("City"),
            new_df.col.location.address.alias('Address'),
            new_df.col.location.locality.alias('Locality'),
            new_df.col.location.locality_verbose.alias('Locality_Verbose'),
            new_df.col.location.longitude.alias('Longitude'),
            new_df.col.location.latitude.alias('Latitude'),
            new_df.col.cuisines.alias("Cuisines"),
            new_df.col.average_cost_for_two.alias("Average_Cost_For_Two"),
            new_df.col.currency.alias("Currency"),
            new_df.col.has_table_booking.alias("Has_Table_Booking"),
            new_df.col.has_online_delivery.alias("Has_Online_Delivery"),
            new_df.col.is_delivering_now.alias("Is_Delivering_Now"),
            new_df.col.switch_to_order_menu.alias("Switch_To_Order_Menu"),
            new_df.col.price_range.alias("Price_Range"),
            new_df.col.user_rating.aggregate_rating.alias("Aggregate_Rating"),
            new_df.col.user_rating.rating_text.alias("Rating_Text"),
            new_df.col.user_rating.votes.alias("Votes")
        )
        final_df.printSchema()
        LOGGER.info("Transformed {}".format(file_name))
        LOGGER.info("Starting conversion of {} to csv file".format(file_name))

        # Define the output CSV path for writing the DataFrame
        output_csv_path = 'file://{}csv/converted'.format(file_path)
        # Write the DataFrame to CSV files
        final_df.write.csv(output_csv_path, mode='overwrite', sep='\t',header=False)
        LOGGER.info("Converted {} to csv file".format(file_name))
        # Display the directory tree structure using the 'tree' command
        os.system("tree /home/talentum/zomato_etl_copy/source/csv/")
        LOGGER.info("Loading {} into source/csv folder".format(filename))

        # Copy the converted CSV files to a timestamp-named directory
        os.system("cp -r {0}csv/converted/*.csv {0}csv/{1}".format(file_path, filename))
        LOGGER.info("Loaded {} into source/csv folder".format(filename))
        # Remove the 'converted' directory
        LOGGER.info("Removing converted files.")
        os.system("rm -rf {}csv/converted".format(file_path))
        LOGGER.info("Removed files.")
        
        # Display the directory tree structure again
        os.system("tree /home/talentum/zomato_etl_copy/source/csv/")