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
#####################################################
# Drop Database From Databases list
function dropDataBase {
	echo -e "\n"
	read -p "Choose Database You Want To Drop It From The Above Databases List : " choise ;
	containsElement ${DBARR[$choise]} "${DBARR[@]}";
	if [[  "$?" == "1" ]]; 
	then
		read -p "Are You Sure Droping ${DBARR[$choise]} Database [Y/N] " response;
		case $response in 
			[yY][eE][sS]|[yY]) 
	        	rm -r $DBPATH/${DBARR[$choise]};
	        	DBARR[$choise]="";
	        	echo -e "\t${DBARR[@]}";
	    	;;
	    	*)
				main;
			;;
		esac	
	else
		{
			printHash;
			echo "out of range";
			listDB;
			dropDB;
		}

	fi

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
				break ;
				;;
			"Use Database")

				break ;
				;;
			"Show Databases")

				break ;
				;;
			"Drop Databas")
			echo "helll"
				dropDataBase;
				echo "hi"
				break ;
				;;
			"Quit")
				exit -1 ;
				break
				;;
				*)
				ErrorChoies;
				;;
		esac
	done
};
main;