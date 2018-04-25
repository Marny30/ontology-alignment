#!/bin/sh

commandprefix="java -jar lib/procalign.jar http://oaei.ontologymatching.org/2014/conference/data/ekaw.owl http://oaei.ontologymatching.org/2017/conference/data/sigkdd.owl -i fr.inrialpes.exmo.align.impl.method.StringDistAlignment -DstringFunction="
listofMesures="levenshteinDistance
smoaDistance
equalDistance
"
comparaison_ref="file://$PWD/realignement/ALIN-ekaw-sigkdd.rdf"
# comparaison_ref="file://$PWD/realignement/ONTMAT-ekaw-sigkdd.rdf"
listofStatMesures="fMeasure
recall
precision"
###############################################################################
#                                   analyse                                   #
###############################################################################
analysis () {
    mkdir realignement
    mkdir realignement/realignement
    mkdir realignement/analysis
    for mesure in $listofMesures; do
        for treshold in `LANG=en_US seq 0 0.1 1`; do
            outputpath="$PWD/realignement/realignement/realign-"$mesure"-"$treshold".owl"
            pathanalysis="$PWD/realignement/analysis/analysis-"$mesure"-"$treshold".owl"

            # Réalignement
            command=$commandprefix$mesure" -t "$treshold;
            # echo $command
            
            # command_stats="java -cp lib/procalign.jar fr.inrialpes.exmo.align.cli.EvalAlign -i fr.inrialpes.exmo.align.impl.eval.PRecEvaluator file://"$outputpath" "$comparaison_ref
            # Analyse
            command_stats="java -cp lib/procalign.jar fr.inrialpes.exmo.align.cli.EvalAlign -i fr.inrialpes.exmo.align.impl.eval.PRecEvaluator "$comparaison_ref" file://"$outputpath
            echo $mesure" : "$treshold" ..."
            # echo $command_stats
            $command 1>$outputpath 2>/dev/null
            $command_stats > $pathanalysis 2>/dev/null
        done;
    done;
}

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
analysis
view

