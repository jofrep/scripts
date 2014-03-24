echo off
openssl genrsa -out privkey.pem 2048
rem pause
openssl dgst -md5 -binary privkey.pem > RandomData.bin 
rem pause
openssl base64 -e -in RandomData.bin -out RandomData.txt 
rem pause
openssl aes-256-cbc -kfile RandomData.txt  -P

del RandomData.txt 
del RandomData.bin  
del privkey.pem
 
