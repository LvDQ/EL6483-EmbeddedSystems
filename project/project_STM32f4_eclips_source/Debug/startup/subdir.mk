################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../startup/startup_stm32f303xc.s 

OBJS += \
./startup/startup_stm32f303xc.o 


# Each subdirectory must supply rules for building sources it contributes
startup/%.o: ../startup/%.s
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Assembler'
	@echo %cd%
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -mfloat-abi=soft -I"D:/EMBEDDED/eclipse/tmp/inc" -I"D:/EMBEDDED/eclipse/tmp/CMSIS/core" -I"D:/EMBEDDED/eclipse/tmp/CMSIS/device" -I"D:/EMBEDDED/eclipse/tmp/HAL_Driver/Inc/Legacy" -I"D:/EMBEDDED/eclipse/tmp/HAL_Driver/Inc" -I"D:/EMBEDDED/eclipse/tmp/Utilities/Components/Common" -I"D:/EMBEDDED/eclipse/tmp/Utilities/Components/l3gd20" -I"D:/EMBEDDED/eclipse/tmp/Utilities/Components/lsm303dlhc" -I"D:/EMBEDDED/eclipse/tmp/Utilities/STM32F3-Discovery" -g -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


