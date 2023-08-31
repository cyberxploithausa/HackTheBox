# Starting point

## Archetype

> Yazeed Ahmed | 5 December 2022

```````````````````````
ip =  10.129.175.0 / 

```````````````````````

## ATTACK Vector

open ports

135/tcp  open  msrpc        Microsoft Windows RPC
139/tcp  open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds Windows Server 2019 Standard 17763 microsoft-ds
1433/tcp open  ms-sql-s     Microsoft SQL Server 2017 14.00.1000.00; RTM



####  TASKS

1.  Which TCP port is hosting a database server? | 1433

2.  What is the name of the non-Administrative share available over SMB? | backups 

3.  What is the password identified in the file on the SMB share? | M3g4c0rp123

4. What script from Impacket collection can be used in order to establish an authenticated connection to a Microsoft SQL Server? | mssqlclient.py

5. What extended stored procedure of Microsoft SQL Server can be used in order to spawn a Windows command shell? | xp_cmdshell 

6. What script can be used in order to search possible paths to escalate privileges on Windows hosts? | winpeas

7.  What file contains the administrator's password? | 

### FLAGS 

user flag: 3e7b102e78218e935bf3f4951fec21a3

root flag: b91ccec3305e98240082d4474b848528


> NB: net.exe use T: \\Archetype\backups /user:administrator MEGACORP_4dm1n!!
