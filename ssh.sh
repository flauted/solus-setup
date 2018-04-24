#!/bin/bash

# Start an ssh server.

eopkg it openssh-server
systemctl restart sshd.service
