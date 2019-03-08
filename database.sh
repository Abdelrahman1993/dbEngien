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

		main;
	
}
#####################################






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
				echo "ddddddddddddddddd";
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