## This is just a update script for myself to make it easier for me to update
sshpass -p "Lisgor43" ssh elerium -T "rm -r ./menprotect/menprotect"
sshpass -p "Lisgor43" scp -r ./menprotect elerium:/root/menprotect