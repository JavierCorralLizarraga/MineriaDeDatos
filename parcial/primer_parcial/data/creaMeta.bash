#!/bin/bash

imports-85.csv

# grep -n '7. At' imports-85.names | cut -f 1 -d ":" # saca el lugar en el archivo de la seccion de atributos
columnas=sed -n 61,89p imports-85.names | cut -f 2 -d "." | cut -f 1 -d ":" | sed "4,6d" | xargs -n26 -d'\n'


echo "$columnas" >> metadata.R
