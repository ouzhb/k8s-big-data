#!/usr/bin/python2.7
# -*- coding: utf-8 -*-
import os
import time

import sys

import paramiko


def ssh(sys_ip, cmds, username="root", password="kcuf"):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        # 密码方式远程连接
        client.connect(sys_ip, 22, username=username, password=password, timeout=20)
        # 互信方式远程连接
        # key_file = paramiko.RSAKey.from_private_key_file("/root/.ssh/id_rsa")
        # ssh.connect(sys_ip, 22, username=username, pkey=key_file, timeout=20)
        # 执行命令
        stdin, stdout, stderr = ssh.exec_command(cmds[key])
        # 获取命令执行结果,返回的数据是一个list
        result = stdout.readlines()
        return result
    except Exception, e:
        print e
    finally:
        client.close()


def format():
    # 通过-nonInteractive格式化，当目录下存在数据时不进行初始化
    os.system("hdfs namenode -format -nonInteractive")


def loop(interval=10):
    os.system("/usr/sbin/sshd -p 52900")
    while True:
        time.sleep(interval)


def start_role(role):
    # TODO: 检查是否启动成功，如果启动失败直接退出
    os.system("$HADOOP_HOME/sbin/hadoop-daemon.sh start {r}".format(r=role))


action_map = {
    "format": format
}

if __name__ == '__main__':
    role = sys.argv[1] if sys.argv.__len__() > 1 else None
    if sys.argv.__len__() > 2:
        action = sys.argv[2]
        action_args = sys.argv[3:]
        action_map.get(action)(*action_args)
    if role:
        start_role(role)
    loop()
