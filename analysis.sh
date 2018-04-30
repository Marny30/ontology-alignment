#!/usr/bin/env bash

source ./config.sh

###############################################################################
#                                   analyse                                   #
###############################################################################
analysis () {
    mkdir realignement
    mkdir realignement/realignement
    mkdir realignement/analysis
    for mesure in $listofMesures; do
        for treshold in $tresholds; do
            outputpath="$PWD/realignement/realignement/realign-"$mesure"-"$treshold".owl"
            pathanalysis="$PWD/realignement/analysis/analysis-"$mesure"-"$treshold".owl"

            # Réalignement
            command=$commandprefix$mesure" -t "$treshold;
            # echo $command
            
            # command_stats="java -cp lib/procalign.jar fr.inrialpes.exmo.align.cli.EvalAlign -i fr.inrialpes.exmo.align.impl.eval.PRecEvaluator file://"$outputpath" "$comparaison_ref
            # Analyse
            command_stats="java -cp align-4.8/lib/procalign.jar fr.inrialpes.exmo.align.cli.EvalAlign -i fr.inrialpes.exmo.align.impl.eval.PRecEvaluator "$comparaison_ref" file://"$outputpath
            echo $mesure" : "$treshold" ..."
            # echo $command_stats
            $command 1>$outputpath 2>/dev/null
            $command_stats > $pathanalysis 2>/dev/null
        done;
    done;
}
analysis
