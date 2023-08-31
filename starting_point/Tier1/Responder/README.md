# Starting point

## Responder

> Yazeed Ahmed | 18 October 2022

```````````````````````
ip =  10.129.248.130

```````````````````````

## ATTACK Vector

open ports

####  TASKS

1. When visiting the web service using the IP address, what is the domain that we are being redirected to? | unika.htb

2. Which scripting language is being used on the server to generate webpages? | php

3. What is the name of the URL parameter which is used to load different language versions of the webpage? | page

4. Which of the following values for the `page` parameter would be an example of exploiting a Local File Include (LFI) vulnerability: "french.html", "//10.10.14.6/somefile", "../../../../../../../../windows/system32/drivers/etc/hosts", "minikatz.exe" |  ../../../../../../../../windows/system32/drivers/etc/hosts

5. Which of the following values for the `page` parameter would be an example of exploiting a Remote File Include (RFI) vulnerability: "french.html", "//10.10.14.6/somefile", "../../../../../../../../windows/system32/drivers/etc/hosts", "minikatz.exe" |  //10.10.14.6/somefile

6. What does NTLM stand for? | new technology lan manager

7. Which flag do we use in the Responder utility to specify the network interface? | -i

8. There are several tools that take a NetNTLMv2 challenge/response and try millions of passwords to see if any of them generate the same response. One such tool is often referred to as `john`, but the full name is what?. | john the ripper

9. What is the password for the administrator user? |  badminton

10. We'll use a Windows service (i.e. running on the box) to remotely access the Responder machine using the password we recovered. What port TCP does it listen on? |  5985


#### FLAG

root flag: ea81b7afddd03efaa0945333ed147fac




