#!/usr/bin/bash
KEYFILE="/home/admin/.ssh/id_rsa"
USERNAME="admin"
# HOSTS=("172.20.0.10" "172.20.0.11" "172.20.0.12")
# SERVERS=("admin@172.20.0.2" "admin@172.20.0.3" "admin@172.20.0.4" "admin@172.20.0.5")
PASSWORD="Citc@1406Abx7k"

# 从文件中读取 HOSTS 列表
read_hosts_from_file() {
  # 检查 hosts 文件是否存在
  if [ ! -f hosts.txt ]; then
    echo "Error: hosts.txt file not found!"
    exit 1
  fi

  # 逐行读取 hosts 文件中的 IP 地址到数组
  # mapfile 或 readarray 是 Bash shell 中的一个内置命令，主要用于从标准输入或文件中读取行到数组变量中
  # -t选项用于删除每行的尾随换行符，HOSTS是我们的数组名称，< hosts.txt表示从hosts.txt文件中读取数据
  mapfile -t HOSTS < hosts.txt
}

keygen() {
  if [ ! -f "$KEYFILE" ]; then
   yum -y install expect
   expect <<EOF
      spawn ssh-keygen -t rsa
      expect {
         "*(/home/admin/.ssh/id_rsa):*" { send "\r"; exp_continue }
         "*(y/n)*"                      { send "y\r"; exp_continue }
         "*Enter passphrase*"           { send "\r"; exp_continue }
         "*Enter same passphrase again:*"   { send "\r"; exp_continue }
         eof                            {exit 0}
      }
      expect eof
EOF
  else
    echo "SSH key $KEYFILE, already exists, skipping generation."
  fi
}

key_copy(){
  if [ -z "$1" ]; then
    echo "Usage: key_copy <HOST>"
    return 1
  fi
  #     spawn ssh-copy-id -o StrictHostKeyChecking=accept-new $1 # 省去秘钥检查验证
  expect <<EOF
   set timeout 20
   spawn ssh-copy-id $1
   expect {
     "yes/no"                     { send -- yes\r; exp_continue }
     "The authenticity of host*"  { send -- "yes\r"; exp_continue }
     "*password:*"    { send -- $PASSWORD\r; exp_continue }
     eof              { exit 0 }
     timeout { puts stderr "Failed to copy SSH key to $1"; exit 1 }
   }
   expect eof
EOF
}

ssh_copy_id_to_all() {
  keygen ;
  SERVERS=()
  for HOST in "${HOSTS[@]}"; do
    # 忽略空行和注释行（以 # 开头的行）
    if [[ -n "$HOST" && "$HOST" != \#* ]]; then
      SERVERS+=("${USERNAME}@${HOST}")
    fi
  done

  for host in "${SERVERS[@]}"
  do
    echo "Copying SSH key to $USERNAME@$host"
    key_copy "$host"
  done
}

read_hosts_from_file
ssh_copy_id_to_all