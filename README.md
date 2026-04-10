# Bottomtext

Install and auto-update sysexts in declarative manner. </br>
This is meant to be a local layering replacement for Fedora, AlmaLinux Kitten 10 and Centos 10.


# Setup

## Install

`just install`

## First initialization run

`just man-run`

## Configure repos

For now, just add needed .repo files in `/etc/yum.repos.d/`

## Configure System Extensions

Enable the systemd unit to auto-update on new bootc update `sudo systemctl enable bottomtextd`

> Check [./bottomtext.d/ ](bottomtext.d/) for working exemples

Create as many `.se` file in /etc/bottomtext/bottomtext.d/ as you want

### `PACKAGES`
Add a field in the .se file with dnf packages names like `PACKAGES=( package1 package2 )`

### `EXTRA_ALLOW_EXEC`
Extra paths to be allowed to execute by SELinux. </br>
/usr is added by default </br>
It is not needed if you only plan to run the binary manually



# Warning

## Unsupported software

- Multilib (Like Steam from RPMFusion)
- Apps with a non usr-merged layout

## Untested

This is not really well tested yet, while simple program should work without issues, more complex services might fail when sysexts are reloaded.