# Simulation of the house developers activity on the Henares Corridor
## Summary

This is an Agent Based Model developed in NetLogo platform that aims to simulate the house developers activity in the Corridor of Henares. The model requieres as inputs numerous information about the studied zone. This information is classified in: land constrictions (related to urban plans zonning), land characterization, land price and land classification.
## Installation

Based on the aplication NetLogo version 6.2.0

## How to Run

Open the file using the aplication, follow the indications below.

## Requirements
 
The model works with high amount of data as input. This makes impossible to run the model with the default configuration of NetLogo since it's capped to use a maximum of 1 gb of RAM. In order to to surpass this limit, it is needed to modify certain .cfg extension files related to the NetLogo folder. 

In Windows this files are usually (depending on your installation location) located at: C:\Program Files\NetLogo 6.2.0\app

In MAC this files are usually (depending on your installation location) located at: /Application/NetLogo 6.2.0/NetLogo 6.2.0.app/Contents/Java 

It is needed to change the 1024 value of all .cfg files to a larger amount, recommended 4096 or superior.

## Files

* ``MODELO_TFM.nlogo``: File of the model itself
* ``datos_entrada``: Folder that contais all the necessary input data to run the model
* ``resultados``: Folder that contains numerous examples of diferent configurations and its outputs



