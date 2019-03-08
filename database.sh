function  main {
	echo "---------------------------------------------------------------------------";
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")

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