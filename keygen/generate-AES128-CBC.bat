echo off
openssl genrsa -out privkey.pem 2048
openssl dgst -md5 -binary privkey.pem > RandomData.bin 
openssl base64 -e -in RandomData.bin -out RandomData.txt 
openssl aes-128-cbc -kfile RandomData.txt  -P

del RandomData.txt 
del RandomData.bin  
del privkey.pem
 
