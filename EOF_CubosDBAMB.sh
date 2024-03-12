#!/bin/bash

sed -i  's/"/\'/g  ;   s/,//g  ;  s/\t{2,}/ - /g   ;  s/\t/","/g  ;   s/^/"/g  ;   s/\n/"/g'     './data/CubosDBAMB_Reserva.csv'     
