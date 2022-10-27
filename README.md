# Speed controller of a vertical axis rotor
This is a university project made for Automatic Control course of prof. Giuseppe Notarstefano at University of Bologna.

## ABSTRACT
The main goal of this project is to desing a control system in order to obtain a constant angular speed of a blades-deformed rotor.
This deformity produces a non-linear system.

<p align="center">
   <img src="images/non-linear-equations.PNG">
</p>




## Variable Definitions 
𝜔 is angular speed <br>
𝜃 is the angle of the blade <br>
β is a coefficient <br>
𝜇𝑑 is the dynamic friction coefficient <br>
𝑚𝑖 is the mass located in the deformity point <br>
𝑒𝑖 is the distance between centre and deformity <br>
𝐼𝑒 is the moment of inertia <br> 
𝜏 is the force applied to the motor. <br>

## Results

Following the Bode diagram of the extended system with the constraints.
<p align="center">
   <img src="images/Diagramma-di-Bode1.PNG">
</p>

Following the Bode diagram of the L function.
<p align="center">
   <img src="images/Diagramma-di-Bode2.PNG">
</p>

Following the Bode diagram of the Step Response function
<p align="center">
   <img src="images/Step-Response.PNG">
</p>

Following the controller design on Simulink
<p align="center">
   <img src="images/Simulink.PNG">
</p>

Following the difference of the noise after and before the use of a high-pass filter
<p align="center">
   <img src="images/DiagrammaFinale.PNG">
</p>


## Credits
- [Giorgio Mocci](https://github.com/giorgio-mocci)
- [Daniel Rajer](https://github.com/telespalladaniel)
