install:
    #!/bin/env bash
        sudo bash -c '
        mkdir -p /etc/bottomtext/bottomtext.d/
        mkdir -p /etc/bottomtext/bin/

        install -m 755 ./bottomtext /etc/bottomtext/bin/
        install -m 755 ./check-bootc-digest.sh /etc/bottomtext/bin/
        install -m 644 ./unit/bottomtextd.service /etc/systemd/system/

        systemctl daemon-reload
    '

uninstall-everything:
    #!/bin/env bash
        sudo bash -c '
        rm -rf /etc/bottomtext/

        rm /etc/systemd/system/bottomtextd.service

        rm /var/lib/extensions/*

        systemd-sysext refresh
        systemctl daemon-reload
    '

man-run:
    sudo /usr/local/bin/bottomtext


    