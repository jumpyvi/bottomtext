# Bottomtext

Install and auto-update sysexts in declarative manner. </br>
This is meant to be a local layering replacement for Fedora, AlmaLinux Kitten 10 and Centos 10.


# Setup

## Install

`just install`

## First initialization run

`just man-run`


## Configure System Extensions

Enable the systemd unit to auto-update on new bootc update `sudo systemctl enable bottomtextd`

> Check [./bottomtext.d/ ](bottomtext.d/) for working exemples

Create as many `.se` file in /etc/bottomtext/bottomtext.d/ as you want

### `PACKAGES`
Add a field in the .se file with dnf packages names like `PACKAGES=( package1 package2 )`

### `EXTRA_ALLOW_EXEC`
Extra paths to be allowed to be executed by SELinux. </br>
/usr is added by default </br>
It is not needed if you only plan to run the binary manually

### `ADOPT_ETC`

> [!NOTE]  
> This does not use Confext as it is completly unusable on fedora, instead, the data is simply moved to your real /etc

Move /etc content distributed by the packages to your /etc
Possible values are:
- `yes` : Move only if file doesnt exist
- `overwrite` : Replace existing files
- `no` : Ignore packages /etc

### `ASSOCIATE_GROUPS`

Add a user to a group using [systemd-sysusers](https://www.freedesktop.org/software/systemd/man/latest/systemd-sysusers.html)

Exemple `ASSOCIATE_GROUPS=( "john libvirt" )`, will associate user "john" to group "libvirt".

A reboot or regenerating group is needed to for this to apply.

Groups/associations will **NOT** be automatically deleted if the file at /etc/sysusers.d/bottomtext.conf is deleted


### `EXTRA_REPO`

Add remote .repo files

`EXTRA_REPOS=( "https://download.docker.com/linux/fedora/docker-ce.repo" )`


### `EXTRA_COPR`

Add a repo from copr

`EXTRA_COPR=( "ublue-os/packages" )`


# Warning

## Unsupported software

- Multilib (Like Steam from RPMFusion)
- Apps with a non usr-merged layout

## Untested

This is not really well tested yet, while simple program should work without issues, more complex services might fail when sysexts are reloaded.