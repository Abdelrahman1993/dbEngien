DBPATH="databases";

#####################################################
function createDatabase {
	read -p "Enter Database Name : " dbName;
	if [[ ! -d $DBPATH/$dbName ]];
		then	
			mkdir $DBPATH/$dbName;
			echo $dbName" Database Created Successfully" ;
		else	
			echo "This Database is Exists";
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