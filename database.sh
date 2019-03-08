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






function  main {
	echo "---------------------------------------------------------------------------";
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				createDatabase;
				echo "ddddddddddddddddd";
				break ;
				;;
			"Use Database")

				break ;
				;;
			"Show Databases")

				break ;
				;;
			"Drop Databas")

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