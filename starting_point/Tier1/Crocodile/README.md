# Starting point

## Crocodile 


> Yazeed Ahmed | 16 October 2022

```````````````````````
ip =  10.129.146.195

```````````````````````

## ATTACK Vector

open ports 
21/tcp open  ftp     vsftpd 3.0.3
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))



####  TASKS

1. What nmap scanning switch employs the use of default scripts during a scan? | -sC

2. What service version is found to be running on port 21?  | vsftpd 3.0.3

3. What FTP code is returned to us for the "Anonymous FTP login allowed" message? | 230

4.  What command can we use to download the files we find on the FTP server?  | get

5. What is one of the higher-privilege sounding usernames in the list we retrieved? | admin

6. What version of Apache HTTP Server is running on the target host? |  2.4.41

7. What is the name of a handy web site analysis plug-in we can install in our browser? |  wappalyzer

8. What switch can we use with gobuster to specify we are looking for specific filetypes? |  -x

9. What file have we found that can provide us a foothold on the target?  |  login.php


### FLAG

root flag: c7110277ac44d78b6a9fff2232434d16