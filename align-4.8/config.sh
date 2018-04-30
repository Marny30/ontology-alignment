#!/usr/bin/env bash
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
