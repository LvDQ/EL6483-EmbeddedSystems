# EL6483_EmbeddedSystems
All course materials, build systems, etc. for the graduate Real-Time Embedded Systems Course, Spring 2017

## This is a project to build a heartrate detector with pedometor using bluetooth to wireless communicate with PC, then shows the data visualization in MATLAB.

The project are written with STM32f4 environment by newest STM company's library HAL_Driver, one should check microcontroller's type then set different values in order to get the HAL library's support. These value and register set should be check within the datasheets.

All datasheets I put them into `./porject/project_STM32f4_eclips_source` 

But there are some `error` datasheets inside with simple logistic or hardware pin position error.  I fixed one in `I2C` part. 

So, good luck and have fun.

Matlab achivement located in `./project`

Main() located in `./porject/project_STM32f4_eclips_source`: 1.src 2.src 3.HAL_Driver