alias q := quick-setup

compile:
    dart compile exe src/bottomtext.dart -o bottomtext


quick-setup: (compile)
    sudo mkdir -p /etc/bottomtext

# remove:
#     sudo systemd-systext refresh
