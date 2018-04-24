#!/bin/bash
eopkg it -y docker 

# reboot

groupadd docker
usermod -aG docker $USER

# reboot
echo "A REBOOT may be necessary!"

# docker run hello-world
