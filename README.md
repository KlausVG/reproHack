# Rendu pour reproHackaton
## Membres du Groupe
- Klaus von Grafenstein (process downloadFastQ, downloadChr, donwloadGtf, écriture README)
- Virginie Noël (process mapFastQ, indexBamFiles, countReads indexGenome)
- Arnaud Maupas (process AnalysStat et script R)
## Objectif du Hackaton
Le but est reproduire les études de <a href="https://www.nature.com/articles/ng.2523" target="_blank">Harbour, Roberson et al. 2013</a> et <a href="https://pubmed.ncbi.nlm.nih.gov/23861464/" target="_blank">Furney , Pedersen et al 2013</a> 
portant sur des données RNA-seq d'individus avec cancers uvulaires, en regardant si les individus ayant la mutation  SF3B1 et ce cancer ont des gènes différemment exprimes de ceux ayant ce cancer aussi, mais pas la mutation, à l'aide d'un workflow réproductible.
## Workflow
![alt text](https://github.com/AnalystCat/reproHack/blob/main/flowchart.png?raw=true)
## Outils utilisés

- Nextflow
 Version 21.10.0.5640 
- Docker
  Version 20.10.11
- Git
  Version 2.25.1 
- SRA Toolkit
Conteneur pegi3s/sratoolkit : version 2.10.0
- STAR
  Conteneur evolbioinfo/star:v2.7.6a : version 2.7.6a 
- SAMtools
  Conteneur evolbioinfo/samtools:v1.11 : version 1.11
- Subread
  Conteneur evolbioinfo/subread:v2.0.1 : version 2.0.1
- R
  Conteneur evolbioinfo/deseq2:1.28.1 : R version 4.0.2
- Package R DESeq2 version 1.28.1
- Package R FactoMineR version 2.4
- Package R factoextra version 1.0.7


## Lancement du workflow
Pour pouvoir lancer le workflow, assurez vu que votre machine possede Newtflow et est au minimun 16 coeurs, 64Go de mémoire vive et 400Go de stockage.
Une fois assurée que votre envriroment de travail est bon, vous pouvez lancer le worflow en vous placant dans le dossier git et en faisant la commande :
``` 
nextflow run pipeline.nf 
```
L'utilisation des options ```-q``` et de ```-bg``` permettent respectivement de éviter que la console affiche les messages des étapes d'excution du nextflow et de lancer an arriere-plan. 
Les differents résultats de l'analyse stastiques devrait se trouver dans le dossier results une fois l'excution terminé.

