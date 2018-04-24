#!/bin/bash

# Wonderfully simple :)

eopkg it -y nvidia-glx-driver-current

echo "A system REBOOT is REQUIRED to load the new driver!!"
echo "If for some reason you get stuck at flickering screen, <Alt>(<FN>)F2 and troubleshoot/uninstall using eopkg."
