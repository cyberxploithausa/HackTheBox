# Starting point

## Dancing


> Yazeed Ahmed | 25 August 2022

```````````````````````
export ip = 10.129.42.48
```````````````````````

## ATTACK Vector

SMB 

``````````````
smbclient -L //10.129.42.48
Sharename       Type      Comment
	---------       ----      -------
	ADMIN$          Disk      Remote Admin
	C$              Disk      Default share
	IPC$            IPC       Remote IPC
	WorkShares      Disk      
SMB1 disabled -- no workgroup available

`````````
### TASKS 

1.  What does the 3-letter acronym SMB stand for? | Server Message Block

2.  What port does SMB use to operate at? | 445

3.  What is the service name for port 445 that came up in our Nmap scan? | microsoft-ds

4. What is the 'flag' or 'switch' we can use with the SMB tool to 'list' the contents of the share? | -l

5. What is the name of the share we are able to access in the end with a blank password? | workshares

6. What is the command we can use within the SMB shell to download the files we find? | get

### FLAG

smbclient \\\\10.129.42.48\\Workshares

root flag:  5f61c10dffbc77a704d76016a22f1664 