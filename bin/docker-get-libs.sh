set -e

ls -x /usr/lib64 >> /before-libs.txt
ls -x /lib64 >> /before-libs.txt 

amazon-linux-extras enable postgresql11
yum install libpq-devel -y

mkdir -p /to-cp
cp /usr/lib64/libpq.so.5 $(ldd /usr/lib64/libpq.so.5.11 | awk '{print $3}') /to-cp/

cd /to-cp

rm -f $(cat /before-libs.txt | xargs) 
