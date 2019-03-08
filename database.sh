DBPATH="databases";

#####################################################
function createDatabase {
	read -p "Enter Database Name : " dbName;
	# regex = 
	if [[ ! -d $DBPATH/$dbName ]];
		then
		if [[ $dbName =~ [a-zA-Z]+$ ]];
			then	mkdir $DBPATH/$dbName;
					if [[ $? -eq 0 ]]; then
						echo -e "\n\t" $dbName" Database Created Successfully" ;
					else	
						echo -e "\n\t Error Done While Creating the Database" ;
					fi
		else
			echo -e "\n\t the name of database is not valied"
		fi
	else	
		echo -e "\n\t This Database is Exists";
	fi

}
###################################################
function listDatabases {
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		let i=i+1;
	done

	if [[ ${#DBARR[@]} -eq 0 ]]; 
		then
			echo "Databases is Empty ";
			main;
	fi
	echo "Available Databases : ";
	i=1;
	for DB in `ls $DBPATH`
	do
		DBARR[$i]=$DB;
		echo $i") "$DB;
		let i=i+1;
	done
		# main;
}

# Drop Database From Databases list
function dropDatabase {
	# echo -e "\n"
	read -p "Choose Database You Want To Drop It From The Above Databases List : " choise ;
	containsElement ${DBARR[$choise]};
	if [[  "$?" == "1" ]]; 
	then
			rm -r $DBPATH/${DBARR[$choise]};
			DBARR[$choise]="";
			echo -e "Deleted successfuly"
	else
		{
			echo "out of range";
			main;
		}
	fi
}
###########################################
# check if array contain an element return 1 if found return 0 if not
containsElement () {
    local e
    for e in "${DBARR[@]}"
    do
        if [[ "$e" == "$1" ]]
            then 
                return 1;
        fi 
    done
    return 0
}
#==================================================
function  main {
	echo "---------------------------------------------------------------------------";
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				createDatabase;
				main;
				break ;
				;;
			"Use Database")

				break ;
				;;
			"Show Databases")
				listDatabases;
				break ;
				;;
			"Drop Databas")
				listDatabases;
				dropDatabase;
				main;
				break ;
				;;
			"Quit")
				exit -1 ;
				break
				;;
				*)
				echo "please choies valied option";
				;;

		esac
	done
};
main;