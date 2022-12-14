# UBUNTU

## adding users in ubuntu bastion host
#! /bin/bash
users=(<list of users seperated by space>)
for usr in ${users[*]}; do
        sudo adduser --disabled-password --shell /bin/bash --gecos "User" $usr
        sudo passwd -d $usr
        sudo su $usr -c "cd && mkdir .ssh"
        sudo su $usr -c "cd && chmod 700 .ssh"
        sudo su $usr -c "cd && touch .ssh/authorized_keys"
        sudo su $usr -c "cd && chmod 600 .ssh/authorized_keys"
        sudo su root -c "cp /home/ubuntu/.ssh/authorized_keys /home/$usr/.ssh/authorized_keys"
        sudo su root -c "echo -e \"bash /etc/script/user_login.sh\" >> /home/$usr/.bashrc"
        sudo chown a4b-admin:a4b-admin /home/$usr/.bashrc
        sudo su root -c "echo -e \"source /etc/bashrc\" >> /home/$usr/.bashrc"
done

# LINUX

## adding users in linux bastion host
#! /bin/bash
users=(a4b-admin arun kk shree vishant tg deepa manish kanagraj praneeth dama harsh deepesh)
for usr in ${users[*]}; do
      sudo adduser $usr
      sudo passwd -d $usr
     	      su $usr -c "cd && mkdir .ssh"
      su $usr -c "cd && chmod 700 .ssh"
                 su $usr -c "cd && touch .ssh/authorized_keys"
     su $usr -c "cd && chmod 600 .ssh/authorized_keys"
     sudo su root -c "cp /home/ec2-user/.ssh/authorized_keys /home/$usr/.ssh/authorized_keys"
done

## push logs to s3
#! /bin/bash
fileName="$(date +%d)-$(date +%m)-$(date +%y)-logs($(date +%T))(UTC).zip"
echo $fileName
sudo zip $fileName /var/log/commands.log
aws s3 cp "${fileName}" s3://a4b-srm-sbox-bastionhost-logs
sudo rm -f $fileName
sudo su root -c "echo -n "" > /var/log/commands.log"

