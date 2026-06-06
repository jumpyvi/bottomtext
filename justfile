alias q := quick-setup

compile:
    dart compile exe src/bottomtext.dart -o bottomtext


quick-setup: (compile)
    sudo rm -rf /var/lib/extensions/bottomtext.raw
    sudo systemd-sysext refresh
    sudo mkdir -p /etc/bottomtext.d/interactive/
    sudo touch /etc/bottomtext.d/interactive/i.yaml
    sudo ./bottomtext

remove:
    sudo rm -rf /var/lib/extensions/bottomtext.raw
    sudo systemd-systext refresh
