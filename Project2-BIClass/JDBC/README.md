## `Inderpreet Singh`
## `CSCI#381`
## `Group#1`

# `JDBC GUI for Project#2`

### **Introduction**
Welcome to the **JDBC GUI Project** developed as part of the **CSCI_381 Project #2** assignment. This project creates a **Graphical User Interface (GUI)** to interact with a database using JDBC (Java Database Connectivity). 

The application allows users to:
- Connect to a database using login credentials.
- Execute SQL commands via a GUI.
- View query results in a dynamic table format.

This project demonstrates the integration of Java, Swing, and JDBC, and provides a hands-on understanding of how GUI applications can interact with relational databases.

---

### **`How to Run the Project`**

#### **`1. Setting Up the Environment`**
Before running the project, ensure you have:
1. **`Java Development Kit (JDK)`** installed on your system.
2. **`Eclipse IDE`** (or your preferred Java IDE).

#### **`2. Adding JDBC Library`**
To enable database connectivity, you must include the JDBC driver library in your project:
1. Download the **JDBC driver for SQL Server** from [Microsoft JDBC Driver for SQL Server](https://learn.microsoft.com/en-us/sql/connect/jdbc/microsoft-jdbc-driver-for-sql-server).
2. Add the JAR file to your project:
   - In Eclipse, right-click your project and go to **Build Path > Configure Build Path > Libraries**.
   - Click **Add External JARs** and select the downloaded JDBC library.
   - Click **Apply and Close**.

---

### **`Default Connection Settings`**
The GUI uses the following default settings for the database connection:

- **Server Name:** `localhost`
- **Port Number:** `13001`
- **Database Name:** *Not required (can be left blank)*  
- **Username:** `sa`  
- **Password:** `PH@123456789`

These values can be modified directly in the login GUI if needed.

---

### **`How the GUI Works`**

1. **`Login Screen`**  
   The application begins with a **login GUI** where you enter the database connection details. Click **Login** to attempt a connection.

2. **`SQL Command Execution`**  
   If the login is successful, the **command execution GUI** opens.  
   - You can type or load SQL commands from a file.  
   - Click **Execute SQL Commands** to run the commands.  
   - Results (if any) are displayed in a table format.

# `README: Installation Instructions for Microsoft JDBC Driver 12.6 for SQL Server`

## **`Introduction`**
This document provides step-by-step instructions for unpacking, installing, and integrating the Microsoft JDBC Driver 12.6 for SQL Server in your Java project. This includes adding the driver to your Java project in Eclipse for use in `BIClass.java`.

Downloading and using the Microsoft JDBC Driver signifies acceptance of the terms in the `license.txt` file. Please review the license before proceeding.

---

## **`Installation for Windows`**

1. **Review the License**:
   - Read the `license.txt` file included with the download.

2. **Download the Driver**:
   - Download the `sqljdbc_<version>_enu.zip` file to a temporary directory.

3. **Extract the Driver**:
   - Unpack the `.zip` file by right-clicking it and selecting **Extract All** or using a file extraction tool.

4. **Specify Extract Directory**:
   - Enter the directory where you want to extract the driver. The recommended location is `%ProgramFiles%` (e.g., `C:\Program Files`), using the default folder name:  
     ```
     Microsoft JDBC Driver 12.6 for SQL Server
     ```
     ---

## **`Adding JDBC Driver to Your Java Projec`t**

To use the extracted JDBC driver in your `BIClass.java` file within Eclipse:

1. **Open Eclipse**:
   - Launch Eclipse and open your project containing the `BIClass.java` file.

2. **Right-Click on the Project**:
   - In the **Package Explorer**, right-click on your project.

3. **Navigate to Properties**:
   - Select **Properties** from the context menu.

4. **Go to the Build Path Section**:
   - In the Properties window, click on **Java Build Path** (or **Build Path** depending on your Eclipse version).

5. **Add the JDBC Driver**:
   - Switch to the **Libraries** tab.
   - Click **Add External JARs**.
   - Browse to the directory where you extracted the JDBC driver.
   - Select the `.jar` file you want to use (e.g., `sqljdbc42.jar` or `sqljdbc41.jar`) and click **Open**.

6. **Apply and Close**:
   - Click **Apply and Close** to save the changes.
