## Description
We've located the adversary's location and must now secure access to their Optical Network Terminal to disable their internet connection. Fortunately, we've obtained a copy of the device's firmware, which is suspected to contain hardcoded credentials. Can you extract the password from it?

- zip password: hackthebox

```bash
unzip Photon\ Lockdown.zip
cd ONT
ls -la
file *
sudo unsquashfs rootfs
```


![[Pasted image 20240728171534.png]]

```bash
cd squashfs-root/
grep -ri htb

```

`password: HTB{N0w_Y0u_C4n_L0g1n}`