# BigData
# Zomato ETL Project

This project demonstrates an Extract, Transform, and Load (ETL) process for processing Zomato restaurant data from JSON format to CSV format using Apache Spark. The project involves loading JSON files, performing transformations, converting data to CSV, and organizing the output files, then storing this data into tables in Hive.

## Table of Contents

- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)

## Project Overview

The main goal of this project is to take Zomato restaurant data in JSON format and convert it into CSV format for further analysis. The ETL process involves several steps:
- Load JSON files using Apache Spark.
- Perform necessary transformations on the data.
- Convert the data to CSV format.
- Organize the CSV files into a timestamp-named directory.
- Clean up temporary files.
- storing data into hive tables.

## Prerequisites

- Python (>=3.6)
- Apache Spark (>=2.4)
- Hadoop YARN (for distributed processing)
- Tree command (for displaying directory structure)
- 
## Setup

1. Clone this repository to your local machine.
2. Install the required dependencies (Apache Spark, Hadoop YARN, etc.).
3. Update the paths and configurations in the script (`script.py`) as needed.
4. Ensure that the JSON files are located in the specified directory.
5. Run the ETL script using the command: `python script.py`

## Usage

1. Place your Zomato restaurant data JSON files in the designated input directory.
2. Follow the setup instructions.
3. Run the ETL script.
4. Check the output directory to find the generated CSV files organized by timestamp-named directories.

## Project Structure

- `script.py`: The main ETL script that performs the extraction, transformation, and loading process.
- `source/json/`: Directory containing input JSON files.
- `source/csv/`: Directory containing output CSV files.
- `README.md`: Project documentation.

## Contributing

Contributions are welcome! If you'd like to enhance the project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and test thoroughly.
4. Commit your changes and push to your fork.
5. Create a pull request detailing your changes.


Author: Snehal Ukey

