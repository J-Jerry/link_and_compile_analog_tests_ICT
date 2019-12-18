#!/bin/bash

clear
x=""
y=0

echo "------------------------------------------------------------------------------"
echo ""
echo "          IMPORTANT: Be sure that this script is into board directory         "
echo "                                                                              "
echo "             This script DOES NOT work with projects versioned                "
echo "------------------------------------------------------------------------------"
echo ""
echo ""

cp -Ri analog/ analog_org          #backup of analog folder

sleep 2
echo "How many boards has this project?
read x 

rm analog/*.o  > /dev/null 2>&1     #delete all .o files
rm analog/*~    > /dev/null 2>&1    #delete all ~ files

cd analog  


while [ $y -lt $x ]; do 

rm list > /dev/null 2>&1                    #delete list file that was created when script was executed
	let y=y+1

for dir in $y%*; do
	echo "$dir" >> list             #generate list with all tests that start with 1%, 2% ....n%
done

#creating files and compile them

cat list | awk '1 { print "analog/", $1 }'  > list_2 #adding analog text to list file named list_2

sed 's/ //g' list_2 > list_3         #delete blank spaces between two columns and save it into list_3

cat list_3 | awk '1 { print "acomp", $1 }' > list_4.sh #create file to compile adding acomp



#linking

cat list_3 | awk '1 { print "ln -f", $1 }' > link_l   #adding ln -f and save it into link_1

	let z=y+1
for lin in $z%*; do
       echo "analog/$lin" >> link    #save into link file all test with 1%,2%....n%

done

paste link_l link > linker.sh  #adding new column from link to link_1 and save it as linker.sh

rm list > /dev/null 2>&1
rm list_2 > /dev/null 2>&1
rm list_3 > /dev/null 2>&1

rm link > /dev/null 2>&1
rm link_l > /dev/null 2>&1

#adding command in the beginning of each row in list_3 file
cp list_4.sh ../list_4.sh 
cp linker.sh ../linker.sh

cd ..
awk 'BEGIN { print "#!/bin/bash" } {print $0}' linker.sh > link_analog.sh
awk 'BEGIN { print "#!/bin/bash" } {print $0}' list_4.sh > compile_analog.sh

rm linker.sh > /dev/null 2>&1
rm list_4.sh > /dev/null 2>&1

./link_analog.sh
./compile_analog.sh    

rm analog/linker.sh > /dev/null 2>&1
rm analog/list_4.sh > /dev/null 2>&1
done
echo ""
echo "Thanks for use it"
echo "		                 Created by Gerardo Alvarez :)"
