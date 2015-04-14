# Settings for unattended installation:
lang en_US.UTF-8
keyboard us
timezone America/New_York
zerombr
clearpart --all --initlabel
rootpw --plaintext atomic
network --bootproto=dhcp --device=link --activate

# We are only able to install atomic with separate /boot partition currently
part / --fstype="ext4" --size=6000
part /boot --size=500 --fstype="ext4"

shutdown

# Including settings created during installer iso compose.
# interactive-defaults.ks is overriden regular kickstart file like this.
# It contains ostreesetup pointing to repo in iso, services enablement, ...
%include /usr/share/anaconda/interactive-defaults.ks

ostreesetup --nogpg --osname=rhel-atomic-host --remote=rhel-atomic-host --url=http://10.34.102.55:8000/ --ref=rhel-atomic-host/7/x86_64/standard
services --disabled=docker-storage-setup

# We copy content of separate /boot partition to root part when building live squashfs image,
# and we don't want systemd to try to mount it when pxe booting
%post
cat /dev/null > /etc/fstab
%end
