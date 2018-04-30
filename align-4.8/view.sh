#!/bin/sh

source config.sh

###############################################################################
#                             Affichage résultats                             #
###############################################################################
view(){
    for sm in $listofStatMesures; do
        echo $sm": "
        for mesure in $listofMesures; do
            for treshold in `LANG=en_US seq 0 0.1 1`; do
                pathanalysis="$PWD/realignement/analysis/analysis-"$mesure"-"$treshold".owl"
                echo "\t"$mesure"-"$treshold":\t"$(cat $pathanalysis|grep $sm|sed 's/<.*'$sm'>\(.*\)<.*'$sm'>/\1/')
            done;
        done;
        echo
    done
}

###############################################################################
#                                     main                                    #
###############################################################################
view
