DBPATH="databases";

#####################################################

function createDatabase {
	echo -e "\n\t---------------------------------------------------";
	IFS= read -r -p "Enter Database Name : " dbName;
	isAlpha='^[a-zA-Z\s]*$';
	if [[ ! -d $DBPATH/$dbName ]];
		then
		if [[ $dbName =~ $isAlpha ]];
			then	
			mkdir $DBPATH/$dbName;
			echo -e "\n\t" $dbName" Database Created Successfully" ;
		else
			clear;
			echo -e "\n\t the name of database should not contaien \n\t space or number or spiceal charachter"
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
	echo -e "\n\t---------------------------------------------------";
	read -p "Choose Database You Want To Drop It From The Above Databases List : " choise ;
	containsElement ${DBARR[$choise]} "${DBARR[@]}";
	if [[  "$?" == "1" ]]; 
	then
			rm -r $DBPATH/${DBARR[$choise]};
			clear;
			#DBARR[$choise]="";
			echo -e "\tDeleted successfuly"
			listDatabases;
	else
		{
			echo -e "\tout of range";
			main;
		}
	fi
}
##########################################
containsElement () {
    local e
    for e in "${@:2}"
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
	echo -e "\n\t---------------------------------------------------";
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
					createTable;
					useDatabase $?;
					break ;
					;;
				"CRUD Table")
					echo "welcome to Crud section";
					listTables;
					crudOperations;
					break ;
					;;
				"Show Tables")
					listTables;
					useDatabase $?;
					break ;
					;;
				"Drop Table")
					listTables;
					dropTable;
					useDatabase $?;
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
			echo -e "\n\tInvalid database selection entry";
			listDatabases ;
			useDatabase;
		}	
	fi
}

#################################################
function createTable {
	echo -e "\n\t---------------------------------------------------";
	isAlpha='^[a-zA-Z\s]*$';
	IFS= read -r -p "Enter Table Name : " tlName ;
		if [[ $tlName =~ $isAlpha ]]
			then
			echo " "
		else
			echo -e "\n\t the name of table should not contaien \n\t space or number or spiceal charachter"
			createTable;
			return $Cho;
		fi
	if [[ ! -e $DBPATH/${DBARR[$Cho]}/$tlName ]]
		then	
			touch $DBPATH/${DBARR[$Cho]}/$tlName;
			chmod +x $DBPATH/${DBARR[$Cho]}/$tlName;
			    echo "Table Name:$tlName " >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    read -p "Enter The Number Of Columns : " tlCol;
					if [[ $tlCol -eq 0 ]]
						then
						echo -e "the number of columns must be greater than zero"
						rm $DBPATH/${DBARR[$Cho]}/$tlName
						createTable;
						return $Cho;
					fi
			    echo -e "The Number Of Columns Is:$tlCol" >> $DBPATH/${DBARR[$Cho]}/$tlName;
			    for (( i = 1; i <= tlCol ; i++ )); do

			    	IFS= read -r -p "Enter Name Of The Column Number $i : " ColName ;
						if [[ $ColName =~ $isAlpha ]]
						then
							echo " "
						else
							echo -e "\n\t the name of Column should not contaien \n\t space or number or spiceal charachter"
							rm $DBPATH/${DBARR[$Cho]}/$tlName
							createTable;
							return $Cho;
						fi
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
	else	
		echo -e "\n\t This Table  Exists";
	fi
	return $Cho;
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
			return $Cho;
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
	return $Cho;
}

##################################################
function dropTable {
	read -p "Choose Table You Want To Drop It From The Above Tables List : " choiseT ;
	containsElement ${TBARR[$choiseT]} "${TBARR[@]}";
	if [[  "$?" == "1" ]]; then
		rm  $DBPATH/${DBARR[$Cho]}/${TBARR[$choiseT]};
		TBARR[$choiseT]="";
	else
		{
			echo "out of range";
			listTables;
			dropTable;
		}
	fi
	return $Cho;
}
##############################################################
function crudOperations {
	echo -e "\n\t---------------------------------------------------";
	choice=$1;
	if [[  "$1" == "" ]]; then
	read -p "Choose Table You Want To Operate On It From The Above Tables List : " tChoice ;
	else {
			let tChoice=choice;
		}
	fi

	echo -e "\n-------------------------------------------------\n";

	containsElement ${TBARR[$tChoice]} "${TBARR[@]}";
	if [[  $? == 1 ]]; then	
		echo -e "${TBARR[$tChoice]} Table Selected\n";
		options=("Insert" "Update" "Display Table" "Display Record" "Delete Record" "Return TO Pervious Menu" "Return TO Main Menu" "Quit");
		PS3="Select Operation : " ;
		select opt in  "${options[@]}"
		do
			case $opt in
				"Insert")
					clear;
					insertRow;
					crudOperations $?;
					break ;
					;;
				"Update")
					clear;
					updateRow;
					crudOperations $?;
					break ;
					;;
				"Display Table")
					clear;
					displayTable;
					crudOperations $?;
					echo "welcome to Display section"
					break ;
					;;
				"Display Record")
					clear;
					displayRw;
					crudOperations $?;
					echo "welcome to Display Record section"
					break ;
					;;
				"Delete Record")
					clear;
					deleteRw;
					crudOperations $?;
					echo "welcome to Delete Record section"
					break ;
					;;
				"Return TO Pervious Menu")
					crudOperations $Cho;
					;;
				"Return TO Main Menu")
					main;
					;;
				"Quit")
					exit -1 ;
				break
				;;
				*)
				echo "---------Invalid Entry---------";
				;;
			esac
		done

	else
		{
			echo "out of range";
			listTables;
		}	
	fi
}

############################################################
declare -a tblColArr
function show_columns()
{
	echo -e "\n\t---------------------------------------------------";
			TblName=$1
			colArrIndex=1      
			noCols=`awk -F: '{if (NR == 2) print $2 }' $TblName`
			lineToShow=$((noCols+4)) # this line contains the table column's names
			pkVal=`cut -f1 -d: $TblName | head -$((noCols+3))  | tail -1 `   #the pk value not pk name
			pkCol=$((pkVal+2))
			pkColName=`cut -f1 -d: $TblName | head -$pkCol  | tail -1 `
			echo "Table Columns : "
			while [ $colArrIndex -le $noCols ]
        do
				curColName=`cut -f$colArrIndex -d: $TblName | head -$lineToShow  | tail -1 ` # to show the names of the columns
			
				tblColArr[$colArrIndex]=$curColName  
				echo  " $((colArrIndex)). $curColName " 
				colArrIndex=$((colArrIndex+1)) 
        done  
			echo "$pkColName Is Primary Key"
}
#####################################

declare -r FND=1;
declare -r NOTFND=0;

function get_column_type()
{
  #show_table_info #######
  curNoCols=$1 #index to the column which be enterd
  
  noCols=$((`awk -F: '{if (NR == 2) print $2 }' $TblName`))
  
  curCellDataType=` cut -f2 -d: $TblName | head -$((noCols+2))  | tail -$noCols | head -$curNoCols | tail -1 `
  if [ $curCellDataType = "Number" ] 
		then 
		echo $FND
  else
		echo $NOTFND
  fi  
  #echo $curCellDataType

}
#############################################
function chk_column_type()
{
	sendColVal=$1 #the user value
	sendColValType=${sendColVal//[^0-9]/} 
	if [[ $sendColVal == $sendColValType ]]
	then 
		echo $FND
	else
		echo $NOTFND   
	fi   
}
##########################################

function checkPrimKey()
{
    sendPkVal=$1 #the user value
      
    noCols=`awk -F: '{if (NR == 2) print $2 }' $TblName`
	ignoredLines=$(($noCols+5))
	ignoredLines=$((`cat $TblName | wc -l `-ignoredLines)) #data rows
	  
	pkVal=$((noCols+3)) 
	pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 ` 
	tstFound=` tail -$ignoredLines $TblName | cut -f$pkVal -d: | grep -w $sendPkVal ` #grep -x or -w or -wn
	  [ $tstFound ] && echo $FND || echo $NOTFND
}

###############################################
function insertRow {

		noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}`));
		ignoredLines=$(($noCols+5))
	  ignoredLines=$((`cat $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]} | wc -l `-ignoredLines))
	  pkVal=$((noCols+5)) 
	  pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]} | head -$pkVal  | tail -1 `
		curNoCols=1 #index to the column which be enterd
		echo "Insert The Columns Values In this Sequense : " # You Want To Insert Into..pk mandatory "
		# to display the columns of the selected table 
		show_columns $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}          
		while [ $curNoCols -le $noCols ]
		do
	  ################################## Check The Cell Data Type #################
	  while true 
	  	do 
			read -p "Enter The $curNoCols Cell Value [You Must Enter Value ] : "  cellValu # update using pk
	    
				curCellDataType=$(get_column_type $curNoCols )
				curColDataType=$(chk_column_type $cellValu )
				if [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 1 ]]
					then break 
				elif [[ $cellValu ]] && [[ $curCellDataType -eq $curColDataType ]] && [[ $curCellDataType -eq 0 ]]
					then break 
					else
					{
						echo "Column Data Type Does Not Match "
					}  
					fi  
			done
	  ################### Check The Primary Key Value ##################  
	  if [ $curNoCols -eq $pkVal ]
	  then 
	    {
				chkPkRtrn=$(checkPrimKey $cellValu)
				if [ $chkPkRtrn -eq 1 ]
					then
					{
						echo "There Is A Row Has This Pk Val ... Try Again"
						break             
					}
				fi
			}  
		fi
####################################################################
		if [ $curNoCols -eq $noCols ]
			then echo -e "$cellValu" >> $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]} 
		else
			echo -n "$cellValu:" >> $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}  
		fi
	  
	  curNoCols=$((curNoCols+1))
		done
		return $tChoice;
}
#############################################
function displayTable
{
	noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}`));
	ignoredLines=$(($noCols+4))
	TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]};
	echo -e "\n--------Table Data ----";
	tail -n +$ignoredLines $TblName
	return $tChoice
}
############################################################
function updateRow
{
	TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}
	noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}`));
	pkVal=$((noCols+3)) 
	pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]} | head -$pkVal  | tail -1 `
  while true 
  do 
		read -p "Which Row You Want To Update Using Primarykey  : " pkToUpdate
    if [ $pkToUpdate ]
			then break
    fi 
  done
  
	pkFnd=$(checkPrimKey $pkToUpdate)
  if [ $pkFnd == 1 ]
  then 
	{
    rowToUpdate=$(row_line_no $TblName $pkToUpdate)
    #  echo "##################" 
    #  echo "The Row Values Are : "
    #  sed -n "${rowToUpdate}p" $TblName 
		echo "##################"  
		sed -i "${rowToUpdate}d" $TblName #&& echo "Row Deleted Successfully" 
	}
  else
	{
    echo "Sorry...This Is Not A PK Value .. Try Again Later "
	} 
  fi

  ############33

  echo "Enter The Row New Values : "
  show_columns $TblName            # to display the columns of the selected table 
  curNoCols=1
  
  while [ $curNoCols -le $noCols ]
  do
	################################## Check The Cell Data Type #################
  while true 
  do 
		read -p "Enter The $curNoCols Cell Value [You Must Enter Value ] : "  cellValu # update using pk
    
			curCellDataType=$(get_column_type $curNoCols )
			curColDataType=$(chk_column_type $cellValu )
      
        if [ $cellValu -a $curCellDataType -eq $curColDataType -a $curCellDataType -eq 1 ]
          then break 
        elif [ $cellValu -a $curCellDataType -eq $curColDataType -a $curCellDataType -eq 0 ]
          then break 
				else
						{
              echo "Column Data Type Does Not Match"
						}  
				fi  
		done
  ##################### Check The Primary Key Value ##################  
  if [ $curNoCols -eq $pkVal ]
  then 
    {
			chkPkRtrn=$(checkPrimKey $cellValu)
			if [ $chkPkRtrn -eq 1 ]
				then
				{
					echo " Dublicated Primarykey Value Which Should Be Unique ";
					continue ;             
				}
		fi
		}  
	fi
		####################################################################
      if [ $curNoCols -eq $noCols ]
			then echo -e "$cellValu" >> $TblName 
      else
        echo -n "$cellValu:" >> $TblName  
      fi
  curNoCols=$((curNoCols+1))
	done
	echo "Row Updated Successfully ";
	return $tChoice;
}
############################################################
#Get Primarykey Line Number

function row_line_no()
{
  TblName=$1 # the send table
  rowToDisplay=$2 # the send pk
  noCols=`awk -F: '{if (NR == 2) print $2 }' $TblName`
  ignoredLines=$(($noCols+5))
  ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
  
  pkVal=$((noCols+3)) 
  pkVal=`cut -f1 -d: $TblName | head -$pkVal  | tail -1 ` #the pk value not pk name
  #################################
	pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `
	pkFndLine=$(($pkFndLine+$noCols+5))
	echo $pkFndLine
}
############################################################
#Display Row With Primarykey
function displayRw()
{
  
  TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}
	noCols=$((`awk -F: '{if (NR == 2) print $2 }' $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]}`));
	ignoredLines=$(($noCols+5))
  ignoredLines=$((`cat $TblName | wc -l `-ignoredLines))
	pkVal=$((noCols+3)) 
	pkVal=`cut -f1 -d: $DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]} | head -$pkVal  | tail -1 `
  rowCounter=$(($noCols+6))
  #################################
  while true 
  do 
   read -p "Enter The Primary Key You Want To Display It's Record: " rowToDisplay
    if [ $rowToDisplay ]
     then break
    fi 
  done
  #################################
  
  pkFnd=$(checkPrimKey $rowToDisplay)
  if [ $pkFnd == 1 ]
  then 
   {
     
     echo "The Result Is : ";
     pkFndLine=`tail -$ignoredLines $TblName | grep -wn $rowToDisplay | cut -f1 -d: `;
     pkFndLine=$(($pkFndLine+$noCols+5));
     sed -n "${pkFndLine}p" $TblName  ;
   }
  else
    echo "No Record Found With This Primarykey Value ";
  fi     
  return $tChoice
}

######################################################
deleteRw()
{
  TblName=$DBPATH/${DBARR[$Cho]}/${TBARR[$tChoice]};
  while true 
  do 
   read -p "Enter The Primarykey You Want To Delete It's Record : " pkToDelete # update using pk
    if [ $pkToDelete ]
     then break
    fi 
  done
 
  pkFnd=$(checkPrimKey $pkToDelete)
  if [ $pkFnd == 1 ]
  then 
   {
    rowToDelete=$(row_line_no $TblName $pkToDelete)
     sed -i "${rowToDelete}d" $TblName && echo "Row Deleted Successfully" 
   }
  else
   {
    echo "Primarykey not found"
		} 
  fi
  return $tChoice;
}
##############################################
function welcome(){
	echo -e "\n\t---------------------------------------------------";
	echo -e "\t\twelcom to SAMMAN and ABDO DBengien"
	echo -e "\t----------------------------------------------------";
}
##############################################

function  main {
	echo -e "\t\n----------------------------------------------------";
	options=("create New Database" "Use Database" "Show Databases" "Drop Databas" "Quit");

	PS3="Enter Your Choice : " ;

	select opt in  "${options[@]}"
	do
		case $opt in
			"create New Database")
				clear;
				createDatabase;
				main;
				break ;
				;;
			"Use Database")
				clear;
				listDatabases;
				useDatabase;
				break ;
				;;
			"Show Databases")
				clear;
				listDatabases;
				main;
				break ;
				;;
			"Drop Databas")
				clear;
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
welcome;
main;