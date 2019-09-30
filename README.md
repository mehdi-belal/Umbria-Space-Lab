# Umbria-Space-Lab
Development of an orientation and pointing system for cubesat

## Introduction

This work deals with solving the problems of orientation, pointing and setting up of a CubeSat nanosatellite.
A CubeSat is a type of cubic-shaped miniaturized satellite (or generally a parallelepiped) with a volume of about 1 dm3 and a mass not exceeding 1.33 kg; generically its electronics and its structure are made with components available in the electronic market (commonly called COTS components).

![mainArch](https://github.com/mehdi-belal/Umbria-Space-Lab/blob/master/doc/cubesat.PNG)

The nanosatellite is an aircraft that rotates around the Earth on a particular orbit, the aircraft uses an antenna to communicate the information gathered at a ground station. In order for this to be possible, it is necessary that the vehicle antenna, mounted on a cube face, is pointed in a specific direction, ie oriented towards the ground station. CubeSat nanosatellites have on board various devices to control attitude and orientation such as reaction wheels, magnetic coils, sun sensors, angular velocity sensors, etc. The reaction wheels can be used to give a pair of forces and generate a rotation around an axis of the vehicle, but the utility of these devices is limited due to saturation. They can be replaced by magnetic coils; these are solenoids that are used to generate torques, letting an adequate current flow, exploiting the Earth's magnetic field. In this way, pairs of forces are generated that are able to rotate the nanosatellite around the axes in which the solenoids are placed, correcting the orientation.
 
This work deals with the study of possible solutions that can solve the problem of the orientation of the nanosatellite, to a specific orbit.

![mainArch](https://github.com/mehdi-belal/Umbria-Space-Lab/blob/master/doc/flight.PNG)

The document of this project (written in Italian) describes in detail all the phases of the project in order to understand the Simulink simulation of the project
