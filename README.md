# gecreate
Simple cli app to create a SELinux .te file

Script was created by Kamil Kugler and should be working on RedHat 8.0. 
It also only works if there is only one class that needs changing
at least for now . I can not take responsibility for any bugs
it might be introducing as I am doing it only
for the fun of it. Use at your own risk!
Free to be reproduced if such a will arise.

# Description

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
