# Simulation of the house developers activity on the Henares Corridor
## Summary

## Installation

Based on the aplication NetLogo version 6.2.0

## How to Run

Open the file using the aplication, follow the indications below.

## Files

* ``MODELO_TFM.nlogo``: File of the model itself
* ``base_info``: Folder that contais all the necessary geografic information to run the model
* ``output``: Folder that contains examples of outputs
## Further Reading
## PARA JULIA

Julia, una de las cosas que he tenido que hacer manualmente es deslimitar el uso de ram de Netlogo. De base viene limitado a utilizar solamente 1gb. He modificado unos archivos .cfg cambiando el valor máximo a 4096. En principio no tenia problema con el modelo de carolina, porque utilizaba un tamaño de pixel de 50 x 50, pero he querido trabajar con una resolución de 25x25 porque se ajustaba mejor a como quería enfocar el modelo. Con esta nueva resolución he tenido los problemas de memoria que te comentaba. Te lo digo por si te crashea al ejecutarlo y probarlo. Para hacer las modificaciones he usado Notepad++ como administrador, modificando todos los archivos cfg de esta ruta: 
C:\Program Files\NetLogo 6.2.0\app [WINDOWS]

/Application/NetLogo 6.2.0/NetLogo 6.2.0.app/Contents/Java/NetLogo.cfg [MAC]

