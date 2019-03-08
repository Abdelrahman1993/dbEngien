DBPATH="databases";

#####################################################
function createDatabase {
	read -p "Enter Database Name : " dbName;
	if [[ ! -d $DBPATH/$dbName ]];
		then
		if [[ $dbName =~ [a-zA-Z]+$ ]];
			then	
			mkdir $DBPATH/$dbName;
			echo -e "\n\t" $dbName" Database Created Successfully" ;
		else
			echo -e "\n\t the name of database is not valied"
		fi
	else	
		echo -e "\n\t This Database is Exists";
	fi
	main;
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
}
###############################################
function dropDatabase {

	read -p "Choose Database You Want To Drop It From The Above Databases List : " choise ;
	containsElement ${DBARR[$choise]};
	if [[  "$?" == "1" ]]; 
	then
			rm -r $DBPATH/${DBARR[$choise]};
			#DBARR[$choise]="";
			echo -e "Deleted successfuly"
			listDatabases;
	else
		{
			echo "out of range";
			main;
		}
	fi
}
##########################################
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

#############################################
# Use Database From Databases list and list Tables Operations
function useDatabase {
	
	choice=$1;
	if [[  "$1" == "" ]]; then
		read -p "Choose Database You Want To Use It From The Above Databases List : " Cho ;
		else {
			let Cho=choice;
		}
	fi
	containsElement ${DBARR[$Cho]} "${DBARR[@]}";
	if [[  $? == 1 ]]; then	
		
		options=("create New Table" "CRUD Table" "Show Tables" "Drop Table" "Return TO Main Menu" "Quit");
		PS3="Enter Your Choice : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"create New Table")
					echo "welcome to create new section";
					createTable;
					break ;
					;;
				"CRUD Table")
					echo "welcome to Crud section";
					break ;
					;;
				"Show Tables")
					listTables;
					break ;
					;;
				"Drop Table")
					echo "welcome to drop section";
					break ;
					;;
				"Return TO Main Menu")
					main;
					break ;
					;;
				"Quit")
					exit -1 ;
					break
				;;
				*)
				echo "Invalid operation entry";
				;;
			esac
		done

	else
		{
			echo "Invalid database selection entry";
			listDatabases ;
			handleDatabase;
		}	
	fi
}

#################################################
function createTable {
	read -p "Enter Table Name : " tlName ;
		if [[ $tlName =~ [a-zA-Z]+$ ]]
			then
			echo " "
		else
			echo "\nTable name not valied\n"
			useDatabase;
		fi
	if [[ ! -e $DBPATH/${DBARR[$Cho]}/$tlName ]]
		then	
			touch $DBPATH/${DBARR[$Cho]}/$tlName;
			chmod +x $DBPATH/${DBARR[$Cho]}/$tlName;
			#if [[ $? -eq 0 ]]; then
				# echo -e "\n\t$tlName Structure" > $DBPATH/${DBARR[$Cho]}/$tlName;
			    echo "Table Name:$tlName " >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    read -p "Enter The Number Of Columns : " tlCol;
			    echo -e "The Number Of Columns Is:$tlCol" >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    # echo -e "$tlName Columns" >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    for (( i = 1; i <= tlCol ; i++ )); do

			    	read -p "Enter Name Of The Column Number $i : " ColName ;
			    	colArr[$i]=$ColName ; 
					echo  -n "$ColName" >> $DBPATH/${DBARR[$Cho]}/$tlName ;
					PS3="Enter Column $ColName Type : ";
					select colType in Number String
					do
						case $colType in
							"Number")
								echo -e ":Number" >> $DBPATH/${DBARR[$Cho]}/$tlName;
								break ;
								;;
							"String")
								echo -e ":String" >> $DBPATH/${DBARR[$Cho]}/$tlName;
								break ;
								;;
      						*)
								echo -e "\n\t Invalid Data Type"
						esac
					done
			    done

			    while true; do
			    	i=1;
				    for col in "${colArr[@]}"; do
					    echo $i")"$col;
					    i=$((i+1)) ;
				    done
			    	read -p "Select Primarykey value : " Pkey;
			    	if [ $Pkey -le $tlCol -a $Pkey -gt 0 ]
		        	then 
		            	echo $Pkey >> $DBPATH/${DBARR[$Cho]}/$tlName;
		            	break ;
			        else
						echo -e "\n\t Invalid Primarykey";
						continue ;
					fi 	
				done
				colArrIndex=1 
				while [ $colArrIndex -le $tlCol ]
				do
					if [ $colArrIndex -eq $tlCol ]
					then echo -e "${colArr[colArrIndex]}" >> $DBPATH/${DBARR[$Cho]}/$tlName;
					else 
					echo -n "${colArr[colArrIndex]}:" >> $DBPATH/${DBARR[$Cho]}/$tlName;
					fi 
					colArrIndex=$((colArrIndex+1));
				done
				echo -e "===========================" >> $DBPATH/${DBARR[$Cho]}/$tlName;  
				
				echo $tlName": Table Created Successfully";
			#else	
				#echo -e "\n\t Error Done While Creating the Table" ;
			#fi
	else	
		echo -e "\n\t This Table  Exists";
	fi
	useDatabase $Cho;
	
}


################################################

function listTables {
	i=1;
	for TB in `ls $DBPATH/${DBARR[$Cho]}/`
	do
		TBARR[$i]=$TB;
		let i=i+1;
	done

	if [[ ${#TBARR[@]} -eq 0 ]]; 
		then
			echo "Database is Empty No tables available";
			useDatabase $Cho;
			return ;
	fi

	echo "Available Tables : ";

	i=1;
	for table in `ls $DBPATH/${DBARR[$Cho]}/`
	do
		TBARR[$i]=$table;
		echo $i") "$table;
		let i=i+1;
	done
	echo -e "\n---------------------------------------------\n";
	useDatabase $Cho;
	# if [[ ! "$1" ]]; then
	# 	return 0;
	# fi

	# if [[ "$1"=="show" ]]; then
	# 	return $Cho;
	# fi

}

##################################################




###########################################
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
				listDatabases;
				useDatabase;
				break ;
				;;
			"Show Databases")
				listDatabases;
				main;
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