openssl genrsa -out privkey.pem 2048
pause
openssl dgst -md5 -binary privkey.pem > RandomData.bin 
pause
openssl base64 -e -in RandomData.bin -out RandomData.txt 
pause
openssl des3 -kfile RandomData.txt  -P

del RandomData.txt 
del RandomData.bin  
del privkey.pem
 
