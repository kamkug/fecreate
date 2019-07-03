# fecreate
Simple cli app to create a SELinux .te file

Script was created by Kamil Kugler
I can not take responsibility for any bugs
it might be introducing as I am dong it only
for fun. Use at own risk!
Free to be reproduced if such a will arise.

DESCRIPTION

The script itself creates a *module.te file only and any further 
action has to be manually performed, at least as of now.
This script is to be run using a permissive mode set to 1
which can be achieved in a following way:

``` 
setenforce permissive
```
due to the fact that selinux needs to allow required actions to let 
a specific process to access its desired destination

# The template it is based on:
```
module mypolicy 1.0;

require {
       type default_t;
       type httpd_t;
       class file getattr;
}

============= httpd_t ==============
allow httpd_t default_t:file getattr;
```
