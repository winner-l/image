#!/bin/bash

echo '
if [ `id -u` -eq 0 ]; then
    export PS1="[\u@\H \W]# "
else
    export PS1="[\u@\H \W]$ "
fi' > /etc/profile.d/hostname.sh

echo '
sshd:192.168.*.*:allow
sshd:172.*.*.*:allow
sshd:10.*.*.*:allow
sshd:123.56.21.191:allow
sshd:123.56.219.58:allow
sshd:106.39.7.*:allow
sshd:124.251.45.5:allow
sshd:124.251.45.10:allow
sshd:124.251.45.8:allow' >> /etc/hosts.allow

echo 'sshd:all:deny' >> /etc/hosts.deny

#sysctl.conf
echo 'net.ipv4.ip_forward = 0


######## important #####################
net.netfilter.nf_conntrack_tcp_timeout_established = 3600
net.ipv4.tcp_timestamps = 0

net.ipv6.bindv6only = 0
net.netfilter.nf_conntrack_max = 6553500

net.ipv4.conf.all.send_redirects = 1
net.ipv4.conf.default.send_redirects = 1
#net.ipv4.conf.eth0.send_redirects = 1

net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.accept_source_route = 0

kernel.printk = 4 4 1 7
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.panic = 10
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296

net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_mem = 786432 2097152 3145728

net.core.optmem_max = 40960
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 5

net.ipv4.tcp_orphan_retries = 0
net.ipv4.ip_local_port_range = 10240  65535

net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_keepalive_time = 1800

net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.lo.rp_filter = 0
#net.ipv4.conf.eth0.rp_filter = 0
#net.ipv4.conf.eth1.rp_filter = 0
#net.ipv4.conf.em1.rp_filter = 0
#net.ipv4.conf.em2.rp_filter = 0
#net.ipv4.conf.bond0.rp_filter = 0
#net.ipv4.conf.bond1.rp_filter = 0
net.ipv4.ip_default_ttl = 255

net.ipv4.conf.all.arp_filter = 1
net.ipv4.conf.default.arp_filter = 1
#net.ipv4.conf.em1.arp_filter = 1
#net.ipv4.conf.em2.arp_filter = 1
#net.ipv4.conf.br1.arp_filter = 1
#net.ipv4.conf.br2.arp_filter = 1
#net.ipv4.conf.eth0.arp_filter = 1
#net.ipv4.conf.eth1.arp_filter = 1

fs.file-max = 1310700
vm.zone_reclaim_mode = 0'> /etc/sysctl.conf
sysctl -p

echo 'export LANG=en_US.UTF-8' >> /etc/profile

# sudo conf
echo '
Defaults    !visiblepw
Defaults    always_set_home
Defaults    env_reset
Defaults    env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"
Defaults    env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults    env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
User_Alias  MOMOBOT = momobot
User_Alias  ZABBIX_AGENT = zabbix

root  ALL=(ALL) NOPASSWD: ALL
%momosu  ALL = (root) NOPASSWD: /usr/bin/momo-su /etc/momo/rootwrap.conf *
%momo   ALL=(ALL) NOPASSWD:     ALL

#includedir /etc/sudoers.d
' > /etc/sudoers

#sshd_config
echo 'Port 22
Protocol 2
SyslogFacility AUTHPRIV
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication yes
PermitEmptyPasswords no
PrintMotd no
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL
X11Forwarding no
AllowTcpForwarding no
Subsystem sftp  /usr/libexec/openssh/sftp-server
TCPKeepAlive yes
ClientAliveInterval 1800
MaxAuthTries 3
ClientAliveCountMax 0
ClientAliveInterval 0
UsePAM yes
UseDNS no' > /etc/ssh/sshd_config
systemctl restart sshd

echo 'ForwardAgent yes
Host *
        GSSAPIAuthentication yes
        ForwardX11Trusted yes
        SendEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
        SendEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
        SendEnv LC_IDENTIFICATION LC_ALL LANGUAGE
        SendEnv XMODIFIERS' >> /etc/ssh/ssh_config

# add user
liu_wenjian='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeZSooY7568kkRSs6OC279Ot0dUFWpX49W+jjTzDwfWv/8fliN7dwwoAoOpFCdPCyC2wn1Vbn0tiag7rvxSs5x7w/QLFfNxYtlWUMcq/CDtSiUT5tM9yVWY779fqGtYdsLjfm69uyYoZEN6z7/PV+ur5m2prxgd5fHKw/04JGV/vMngfk4BungWrUA0y4xWSMa7WQYNB3DKsABfg/l/8X5orfDWZk+eQa1H0E0sgwyx2z92LT2u8h012cDDGiIfmbfDVKD2NV8ZX0YuuaASxQ86ShwdvKJPs02Yl05JCaoFWDTwhc5JI/gOWkJxrcr5i9wyh5WEzyptBD/m31yVKMt liu.wenjian-0'
wang_jingxue='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuW3R8kSI9W6J+VSJJb83CQnm2fbQ1NJSHxEiWn8cpS02msrjhEUmKOGyOYX+1Tl2T0qk9iCUhqC2MjaKLSFum9sLHNz2cKYvdNHNycFsed5IH1Bth17N3xLefkonqFAQnwALOtERiOWkmbFyhbtQhTaY8jnnMMrVguyqcp7QiLzpaavU/vYV+FBqfV9b2rBPqvnVe1tQGKS/NclbZSKVFqglRk1JAuY/MI3BQZjauuTdbxsFvxnii8O3jHKO6yWI9njIs+YJ9blzH8Y1LWCZVxhcdI9Xy22Sa8278xL6XFFY4rSILWIKdkPWEpuSt2RHL80Jy1EYJmHn67O5xfiwH wang.jingxue-0'
leo='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEe4Rh1ZURsR78ayip7nYt0go6RmGtrre5/+dsMe6NRV54mB8YFcbtqP6Xq8i3OQtaeDLopAdnD5Xu+WcNZBCevc4EnrEszOw37tFD36+PM7qFvCmqditK1IvnWgVHJUM2tnqU6cFpXgdNPgy1CdYXw0hEmlF8r87e0pz3KlgR1kNWMTXIEwFtTdKvE3DS19bRibUJnOSRxHWfiws1xLxrMvUhz4VFxXSfHKPKWj1Zm5Q6m8M8Asng952yfENCwTh4X70TaiDC3Rs3S9RHwrlY+Fi/FKsYqoJuNbnu1cq6JR4ftwVIMyyiKPn2yqSZzlr7y8NTRlO6FGbHTJTVPb6v leo-1
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtP2OXApqh92ZMqn+tFCRRtOXJcCcBo0cacnKY2EhokBF+AXIj/ECnimKGnO7b3j/Q5WWVKUH2+NfosXmuBqUfJ6hMx/7TTDy2ZijSGxYcO9QkQajBe75v2nsntUoLeWrQDaqL/Mymn3uTfskvacW9/JvPan7SLwkiwofihsR8l7aGrwAR2NUbosIfnt3EbWAan7YCqaD9G/7TYAwLegcq+QU2aKOor87Poxcn04NjXBLR+CmKDdqLLFOyxqymTuijfRM98OjPlbenI8PZJkYTMXCw3oR1bC4yGktmViZjbQoglZsHJsu6PppGK4QeG/leeIiN2Db1KGqx6szy0ikiw== leo-0'
yang_huizhao='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmb+y7ZrXOIWjWQkXsaPt1MQbxTsFlux8Ck2eONglLGNg4m+xtQ5aDSfN3rwofmQRCqtNV7F3gBvnsVRiqQe0cIUiLHz7kMQK/0FZDVNyvcGNdwk/AERr+0znVeJbEcBYRp4kJgFKI4/ubhEU/pZ7KYzKM379/Rc7lhdaPMV4EDJNkr2UDrNhipszuH6c0GRWiRteQGc1noOwstpF6DF6J5WOUKGdN1HofjPMT70GkYPG6QN4ZJuQ/eOxFNZJErzjb+pZixVowuGxD+MXvu3/afwlij8klpCMNSIEZxZwls4DJv1kH4u+lU/AhsMZKHM2Z7a/BIOh9fSspf5zhvq5t yang.huizhao-0'
harvey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf84+JjCBikyhdrLtV322DX5V2GaF8nPH1UbnUmewVvHIOQRI0SRjFOqIC6ApfaQ/AH1QVPaeAUl/pjNtOxn0EKpL5lgUPp9IV7GQvECtJBLFqdRDJ0L2J4sXg66McvP/Sm25yNnb/c3AwvzQtOg7eQXFpZcSdOjCmRXuJ5QTlh1Zy+s91RSIggBCaDeqmabKWf+6e5KOtwbZ4gN3SlHzrcz2grDyjY309D4mEurn80dlHN9qLJPpV/6OUcMPaRiLS62BVtmSmRoOfYJjNxde6SATLY9cg0UqsMKXzsCQ0Y02dYIp8xAkrxPNy++H+YuSxAXqYeL3RCWdOicy4xB75 harvey-0'
tang_peiliang='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCxmeFZHOsOG3GKnV4N5BwocKHHJrr9GS1pGwZu3l0/EoeF1f6P/umbHGTUh9DAQmZ5/ArfFMhPo5gohzHGfD1ZGCIT42L/lvYAqQ8gV3a8hLla63bBEh694fXJo1xEkxmqBnG3YaG81Va95B0KZxw7/H0QcgYvOv0OLFJXfqUp0Q== tang.peiliang-0'
xu_huiqing='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDZB5hMeUMJp7iWS/TtSOXjxPvnjtJ1fbScEJZWPclrQqFv8kQhieXETlEF/yHY01tpgqBkSzMpUZkvek6T7J6C1f+bSYSN58/yKBY8H6aaiiSM8qPG4XN0ng4W7WAieRSql/HgO6Twersta79YMY0/q+uT0zKB4O/lMJLrIw8KLQ== xu.huiqing-0'
shang_hongwei='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRkn5/jt0qH5MLVtHosQKhTdRiufN+IpMjfbq//kNupM1Q9xJZtd6Ff+yp4byqWYUdYyizVmIN0eCf29qg/5lU0ZzDwDjC7mhyOJ3W7HuLW0wgE/CNUKJMizb5XiCTZiYIScFSlEzC1gFJh+HWHlx/XuJYuL87caRMoudaZrY93o/CFezGO8nGTydsj8jJ+LgFBDhb68RDkwwnMFTgdciu6ilEhsF/h5ftz9VLDtc5tkOCPRLjAI3fIFWyDiIRsNshh7iv1KTtMWIG9eHKAmQytoKb55VT+joWU1sY7aOGkKOmp8NqNivZJf3Ct6EAjtc9S1lGsgV/7COYEAepos7h MOMO@MOMOdeMacBook-Pro.local'
wu_tao='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQC9qnKByhlSCUEPA3xWPnGk2hm8kN8X+3DJ9Xxb5VdzDkce9vUzCo56Tn2bHN0H1o9vWGvQ/apAMvsKzPMH5sxZEwILoM7sihhD2xkFGupEbpXZzcFWaL+1OvCmPV7qIimQw+BS2cXwRsVxz6LxNoVL7hto2eEt0pJLyXi4Sst9WQ== wutao@wutaodeMacBook-Pro.local'
wang_xueliang='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDX4SNyCnuhLIQ30edB/aeirxYMSe7slplHtgfT/goBri9YU5OHEbOxAu9vJEp5FWQa7mkBwUNIsR1/mDShk0fuhct2e4yo/kTvQu2I+kw+WVnDydt4fPHaohM4r2QJs3wuFbfMBU3rGZap0O1XF03lfzabkTCtmJZe5yVUIi2vGQ== wangxl@wangxl-PC'
yin_cong='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuy5o6MuP8VwKHLfZRVLMvEIesj4WI9qgE1oUrBUeLxax0SgExo6fiYJnj0PfhoIQ7m6ujBJCivxGYrf9STBHNBDyQKMXHyk8RWrvjEXXK1eiWvZkEMdeckj2hnubKJ3X1YbQ8lxH94xwbpKlqZ61Z4NrRq8z7a++1MGnJYoE9F1uLFtgI5nOWKaShHtGW3enlSuE0EC9uaUvbgKVri65YplOhnjeb4kR8hVa9ywvV000BbwOhlCC6c28Lx+MpL0dCkOVaBW8kA1JAj9V/Pjpb8ZM3PCpwFR3TZDN2beUXVDufBfumkGA4RYTwOWk8WH28AvTMODlTJcvmMG3qhdN5 MOMO@bogon'

groupadd momo
for i in `echo liu.wenjian wang.jingxue leo yang.huizhao harvey tang.peiliang xu.huiqing shang.hongwei wu.tao wang.xueliang yin.cong`
do
    useradd -G momo $i
    mkdir /home/$i/.ssh/ ;touch /home/$i/.ssh/authorized_keys
    chown -R $i:$i /home/$i/.ssh/;chmod 700 /home/$i/.ssh/;chmod 600 /home/$i/.ssh/authorized_keys
done

echo "$liu_wenjian"  > /home/liu.wenjian/.ssh/authorized_keys
echo "$wang_jingxue"  > /home/wang.jingxue/.ssh/authorized_keys
echo "$leo"  > /home/leo/.ssh/authorized_keys
echo "$yang_huizhao"  > /home/yang.huizhao/.ssh/authorized_keys
echo "$tang_peiliang"  > /home/tang.peiliang/.ssh/authorized_keys
echo "$xu_huiqing"  > /home/xu.huiqing/.ssh/authorized_keys
echo "$shang_hongwei"  > /home/shang.hongwei/.ssh/authorized_keys
echo "$wu_tao"  > /home/wu.tao/.ssh/authorized_keys
echo "$wang_xueliang"  > /home/wang.xuelaing/.ssh/authorized_keys
echo "$yin_cong"  > /home/yin.cong/.ssh/authorized_keys

systemctl stop firewalld
systemctl disable firewalld

yum groupinstall -y 'Development and Creative Workstation'

cat  >> /etc/profile.d/momo.sh  << EOF
alias 'superctl'='supervisorctl -c /home/server/supervisor/etc/supervisor.conf'
alias 'superd'='supervisord -c /home/server/supervisor/etc/supervisor.conf'
alias 'superctl_http'='supervisorctl -c /home/server/supervisor/http_etc/supervisor.conf'
alias 'superd_http'='supervisord -c /home/server/supervisor/http_etc/supervisor.conf'
EOF

yum install supervisor -y
yum install python-pip -y
pip install supervisor
mkdir -p /home/server/supervisor/etc
mkdir -p /home/server/supervisor/log

cat >> /home/server/supervisor/etc/supervisor.conf << EOF
[unix_http_server]
file=/home/server/supervisor/log/supervisord.sock

[inet_http_server]
port=127.0.0.1:9001

[supervisord]
logfile=/home/server/supervisor/log/supervisord.log
logfile_maxbytes=50MB
logfile_backups=10
loglevel=info
pidfile=/home/server/supervisor/log/supervisord.pid
nodaemon=false
minfds=60000
minprocs=200
#directory=/home/server/supervisor/
childlogdir=/home/server/supervisor/log/

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///home/server/supervisor/log/supervisord.sock ; use a unix:// URL  for a unix socket

[include]
files = /home/server/supervisor/etc/*.supervisor
EOF
