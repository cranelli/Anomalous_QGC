#!/bin/bash
#Set up to take the ISR and FSR signal samples, make reco histograms for each, and make histograms
#for the weighted merger. 
#Example
# ./MakeRecoPDFCategoryHistograms.sh /data/users/cranelli/WGamGam/ReFilterFinalNtuple/NLO_LepGammaGammaFinalElandMu_2015_6_26_ScaleFactors_PDFReweights/


SKIM_PATH=$1
SKIM_NAME=${SKIM_PATH%?} #Removes Last Character, should be a '/'

SKIM_NAME="${SKIM_NAME##*/}" 


SUFFIX="RecoCategoryHistograms.root"

ISR_DIR="job_NLO_WAA_ISR/"
FSR_DIR="job_NLO_WAA_FSR/"

ROOT_NAME="tree.root"

FILE_ISR=$SKIM_PATH$ISR_DIR$ROOT_NAME
FILE_FSR=$SKIM_PATH$FSR_DIR$ROOT_NAME

HIST_DIR="../Histograms/"

OUT_ISR=$SKIM_NAME"/ISR_"$SUFFIX
OUT_FSR=$SKIM_NAME"/FSR_"$SUFFIX


cd ../../python;

# Make Generator Level Histograms
echo python MakeRecoPDFReweightCategoryHistograms.py $FILE_ISR $OUT_ISR
python MakeRecoPDFReweightCategoryHistograms.py $FILE_ISR $OUT_ISR

echo python MakeRecoPDFReweightCategoryHistograms.py $FILE_FSR $OUT_FSR
python MakeRecoPDFReweightCategoryHistograms.py $FILE_FSR $OUT_FSR

cd ../test/scripts

# Merge the ISR and FSR samples together, using their respective weights

#echo $OUT_FSR | sed 's/FSR/WeightedTotal/'
OUT_WEIGHTED=$(echo $OUT_FSR | sed 's/FSR/WeightedTotal/')
#echo $OUT_WEIGHTED
echo python weightAndAddHistograms.py $HIST_DIR$OUT_ISR $HIST_DIR$OUT_FSR $HIST_DIR$OUT_WEIGHTED
python weightAndAddHistograms.py $HIST_DIR$OUT_ISR $HIST_DIR$OUT_FSR $HIST_DIR$OUT_WEIGHTED





