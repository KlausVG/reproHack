# Rendu pour reproHackathon
## Membres du groupe
- Klaus von Grafenstein (process downloadFastQ, downloadChr, donwloadGtf, écriture README)
- Virginie Noël (process indexGenome, mapFastQ, indexBamFiles, countReads)
- Arnaud Maupas (process statAnalysis et script R)
## Objectif du Hackathon
Le but est reproduire les études de <a href="https://www.nature.com/articles/ng.2523" target="_blank">Harbour, Roberson et al. 2013</a> et <a href="https://pubmed.ncbi.nlm.nih.gov/23861464/" target="_blank">Furney, Pedersen et al 2013</a> 
portant sur des données RNA-Seq d'individus avec un cancer oculaire, en regardant si les individus ayant la mutation SF3B1 ont des gènes différemment exprimés de ceux ayant également ce cancer, mais pas la mutation, cela à l'aide d'un workflow reproductible.
## Workflow
![alt text](https://github.com/AnalystCat/reproHack/blob/main/flowchart.png?raw=true)
## Outils utilisés

- <a href= "https://www.nextflow.io/"> Nextflow </a>
 Version 21.10.0.5640 
- <a href= "https://www.docker.com/"> Docker</a>
  Version 20.10.11
- <a href= "https://git-scm.com/"> Git</a>
  Version 2.25.1 
- <a href= "https://hub.docker.com/r/pegi3s/sratoolkit"> SRA Toolkit</a>
Conteneur pegi3s/sratoolkit : version 2.10.0
-  <a href= "https://hub.docker.com/r/evolbioinfo/star:v2.7.6a"> STAR</a>
  Conteneur evolbioinfo/star:v2.7.6a : version 2.7.6a 
- <a href= "https://hub.docker.com/r/evolbioinfo/samtools:v1.11"> SAMtools</a>
  Conteneur evolbioinfo/samtools:v1.11 : version 1.11
- <a href= "https://hub.docker.com/r/evolbioinfo/subread:v2.0.1"> Subread</a>
  Conteneur evolbioinfo/subread:v2.0.1 : version 2.0.1
- <a href= "https://hub.docker.com/r/evolbioinfo/deseq2:v1.28.1"> R</a>
  Conteneur evolbioinfo/deseq2:v1.28.1 : R version 4.0.2
- <a href= "https://bioconductor.org/packages/release/bioc/html/DESeq2.html"> Package R DESeq2  </a> version 1.28.1
- <a href= "http://factominer.free.fr/index_fr.html"> Package R FactoMineR </a> version 2.4
- <a href= "https://cran.r-project.org/web/packages/factoextra/index.html"> Package R factoextra </a>version 1.0.7


## Lancement du workflow
Pour pouvoir lancer le workflow, assurez-vous que votre machine possède Nextflow et ait au minimum 16 coeurs, 64Go de mémoire vive et 400Go de stockage.
Après avoir vérifié que votre environnement de travail est correcy, vous pouvez lancer le workflow en vous placant dans le dossier git et en faisant la commande :
``` 
nextflow run pipeline.nf 
```
L'utilisation des options ```-q``` et ```-bg``` permettent respectivement d'éviter que la console affiche les messages des étapes d'exécution du workflow et de le lancer en arrière-plan. 
Les différents résultats de l'analyse statistique se trouvent dans le dossier results une fois l'exécution terminée.
