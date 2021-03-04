#!/bin/csh -f
#=====================================================================================#
# File name:     sva_gen.csh
# Author:        hungbk99
# Note:          generate sva setting file for ECM_FV check
# Syntax:        sva.csh <file.xlsx>  <output>
#                <file.csv>:sva check list
#                <output> destination file
#=====================================================================================#
# Version       Date        Author        Description
# ver1.0        28.8.2020   hungbk99      New creation
#=====================================================================================#

if ($#argv != 2) then
    echo 'Error Syntax'
    echo      'Syntax: sva.csh <file.csv> <output>'
else
    set source = $1
    set dest = $2
    @ row_limit = `sed -n '$=' ./$source`
    echo    $row_limit
    @ row = 3
     
   while ($row <= $row_limit)
       set ignore = `awk -F, -v var=$row 'NR==var{print$1}' ./$source` 
       #    echo $ignore
         if ($ignore != "ignore") then
         #    Column handling
             awk -F, -v var=$row 'NR==var{print"ECM_"$3"_"$2": assert  property ("$3}' ./$source | tee -a ./$dest
             echo "(" | tee -a ./$dest
   
             @ column_1 = 4
             @ column_2 = 5
             @ column_3 = 6
             @ column_4 = 7
             set check =    ` awk -F, -v var3=$row -v var4=$column_3 'NR==var3{print$var4}' ./$source`         
             set check_1 =    ` awk -F, -v var3=$row -v var4=$column_4 'NR==var3{print$var4}' ./$source`         
             while (!(($check == "_end") || (($check_1 == "_end") && ($check == "_num"))))      
        
                if ($check == "_num") then
                    @ column_3 = $column_3 + 1
                    #awk -F, -v var1=$column_1  -v var2=$column_2 -v var3=$row -v var4=$column_3 'NR==var3{print "\t"$var1"("$var2"["$var4"]""),"}' ./$source | tr -d . | tee -a ./$dest          #print sensitive list
                    awk -F, -v var1=$column_1  -v var2=$column_2 -v var3=$row -v var4=$column_3 'NR==var3{print "\t"$var1"("$var2"["$var4"]""),"}' ./$source | tee -a ./$dest          #print sensitive list
 
                    @ column_1 = $column_3 + 1
                    @ column_2 = $column_3 + 2 
                    @ column_3 = $column_3 + 3
                    @ column_4 = $column_3 + 2  
                else
                    awk -F, -v var1=$column_1  -v var2=$column_2 -v var3=$row 'NR==var3{print "\t"$var1"("$var2"),"}' ./$source  | tee -a ./$dest          #print sensitive list
                    @ column_1 = $column_3
                    @ column_2 = $column_3 + 1 
                    @ column_3 = $column_3 + 2
                    @ column_4 = $column_3 + 2
                endif
                
                set check =    ` awk -F, -v var3=$row -v var4=$column_3 'NR==var3{print$var4}' ./$source`         
                set check_1 =    ` awk -F, -v var3=$row -v var4=$column_4 'NR==var3{print$var4}' ./$source`         
                #    echo $check_1    
                #    echo $check
             end
    
             if ($check == "_num") then
                 @ column_3 = $column_3 + 1
                 awk -F, -v var1=$column_1  -v var2=$column_2 -v var3=$row -v var4=$column_3 'NR==var3{print "\t"$var1"("$var2"["$var4"]"")"}' ./$source  | tee -a ./$dest          #print sensitive list
             else
                 awk -F, -v var1=$column_1  -v var2=$column_2 -v var3=$row 'NR==var3{print "\t"$var1"("$var2")"}' ./$source |  tee -a ./$dest          #print sensitive list
             endif
             
             echo "));" | tee -a ./$dest
             printf "\n"
         endif
       @ row = $row  + 1
   end
   sed -e "s/
//" $dest $dest     #remove carriage return characters Ctrl+v -> Ctrl + m
endif
