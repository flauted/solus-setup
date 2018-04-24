# Default Solus doesn't include sbin in path. Guess most people don't need fdisk?
echo 'export PATH="$PATH:/sbin"' >> /usr/share/defaults/etc/environment
