# ActiveDirectory User Info Script

## Description

This script retrieves information about Active Directory users based on input provided in a CSV file. It allows you to specify the properties you want to extract for every user and generates an output file with the requested details.

## Main Use Case

Once the users information is collected, the output CSV file can be used with the Mail Merge feature in Word to send customized emails to every user listed in the CSV.

For a detailed guide on how to use Mail Merge in Word, refer to this [help article](https://helpdesk.concord.edu/kb/article/122-how-to-do-a-mail-merge-in-word-using-an-excel-spreadsheet/).

## Input CSV File Format

### Header

The header refers to the first row of a CSV file. In this script, it defines the property type of values that are or will be present in each column.

- The first value of the header specifies the type of property for the user identifier; this must be a unique identifier.
- All subsequent values in the header represent the desired properties to be included in the output file.

You can view the complete list of available properties using the PowerShell command:

```powershell
Get-AdUser <your user account> -Properties *
```

Additionally, aliases have been created for common property names. Here is the list of aliases:

| Property       |  Alias    |
|       :-:      |   :-:     |
| SamAccountName | Username  |
| EmailAddress   | Email     |
| Surname        | FirstName |
| GivenName      | LastName  |

### User Identifiers

All subsequent rows should contain the user identifier values corresponding to the property defined in the first element of the header. These values represent the users you wish to retrieve information about.

### Input File Example:

This is a valid input file:

```csv
Username,FirstName,Email
marco255
lynda24
```

When run through the script, if the users are found and the properties are set, it would return the output file:

```csv
Username,FirstName,Email
marco255,Marco,marco255@company.com
lynda24,Lynda,lynda24@company.com
```

## Setup

By default, the script will only query users on the local Active Directory server. To query additional servers, add them to the `servers.txt` file, with each server listed on a separate line.

### Example `servers.txt` file:

```txt
localhost
my.adServer.net
my.adServer2.net
10.0.0.115
```

## Usage

1. Create or copy an input CSV file into the root of the script directory
2. Run `start.bat`
3. Enter the name of the input file when prompted
4. If the script is successful, the output file will be generated in the same directory with the requested properties
