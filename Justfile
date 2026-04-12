install:
    #!/bin/env bash
        sudo bash -c '
        mkdir -p /etc/bottomtext/bottomtext.d/

        mksquashfs ./src ./bottomtext-manager.raw
        mv ./bottomtext-manager.raw /var/lib/extensions/
        install -m 644 ./unit/bottomtextd.service /etc/systemd/system/

        systemd-sysext refresh
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


    