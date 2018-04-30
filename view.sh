#!/usr/bin/env bash


source $PWD/config.sh
output_prefix="./graphiques/"
###############################################################################
#                         Génération des fichiers .dat                        #
###############################################################################
build_dat_files(){
    
    for sm in $listofStatMesures; do
        # echo $sm": "
        printf "\n"$sm"\n" 
        csv_string="# seuil "
        for measure in $listofMesures; do
            csv_string=$csv_string"\t"$measure
        done
        csv_string=$csv_string"\n"
        output_file=$output_prefix$sm".dat"
        # for treshold in `LANG=en_US seq 0 0.1 1`; do
        #     csv_string=$csv_string$treshold", ";
        # done
        # csv_string=$csv_string"\n"
        for treshold in $tresholds; do
            # csv_string=$csv_string$mesure"\t"
            csv_string=$csv_string$treshold
            for mesure in $listofMesures; do
                pathanalysis="$PWD/realignement/analysis/analysis-"$mesure"-"$treshold".owl"
                # printf "\t"$mesure"-"$treshold":\t"
                csv_string=$csv_string$(cat $pathanalysis|grep $sm|sed 's/<.*'$sm'>\(.*\)<.*'$sm'>/\1/')"\t"
                # echo $(cat $pathanalysis)
    # |grep $sm|sed 's/<.*'$sm'>\(.*\)<.*'$sm'>/\1/')"\t"
                # echo $csv_string
            done;
            csv_string=$csv_string"\n"
        done;
        echo -e $csv_string > $output_file
        echo "output written in "$output_file
    done
}

###############################################################################
#                             Génération de graphe                            #
###############################################################################
buildgraph(){
    oldpwd=$PWD
    cd $output_prefix
    statmesure=$1.dat
    output="$1.png"
    config="
set title '$1 en fonction de la mesure et du seuil'
set xlabel 'Seuil'
set ylabel 'Mesure de distance'

set key bottom right

set terminal pngcairo
set output '$output'

set style line 11 lc rgb '#808080' lt 1
set border 3 back ls 11
set tics nomirror
set style line 12 lc rgb '#808080' lt 0 lw 1
set grid back ls 12

# color definitions
set style line 1 lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 1 lt 1 lw 2 # --- green
set style line 3 lc rgb '#1a369c' pt 2 ps 1 lt 1 lw 2 # --- blue

# Remove border around chart
#unset border

plot '$statmesure' using 1:2 title 'levenshteinDistance' with lp ls 1,\
'$statmesure' using 1:3 title 'smoaDistance' with lp ls 2,\
'$statmesure' using 1:4 title 'equalDistance' with lp ls 3
"
    gnuplot  <<EOF
$config
EOF
    echo "graph done for $statmesure in $output"
    cd $oldpwd
}

build_dat_files
mkdir graphiques
for sm in $listofStatMesures; do
    
    buildgraph $sm;

    done
