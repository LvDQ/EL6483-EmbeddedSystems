/**
  ******************************************************************************
  * @file    main.c
  * @author  Ke Yang, Jiadong Chen
  * @version V1.0
  * @date    28-April-2017
  * @brief   Default main function.
  ******************************************************************************
*/

#include "uart_hal.h"

static UART_HandleTypeDef UartHandle;

static void UART1_Init(void)
{
	GPIO_InitTypeDef  GPIO_InitStruct;

	__HAL_RCC_GPIOC_CLK_ENABLE();
	__HAL_RCC_GPIOC_CLK_ENABLE();
	__HAL_RCC_USART1_CLK_ENABLE();
	/* UART TX GPIO pin configuration USART2_TX=PD5, USART1_TX=PC4 */
	GPIO_InitStruct.Pin       = GPIO_PIN_4;
	GPIO_InitStruct.Mode      = GPIO_MODE_AF_PP;
	GPIO_InitStruct.Pull      = GPIO_PULLUP;
	GPIO_InitStruct.Speed     = GPIO_SPEED_FREQ_HIGH;
	GPIO_InitStruct.Alternate = GPIO_AF7_USART1;

	HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

	/* UART RX GPIO pin configuration  USART2_RX=PD6,USART1_RX=PC5 */
	GPIO_InitStruct.Pin = GPIO_PIN_5;
	GPIO_InitStruct.Alternate = GPIO_AF7_USART1;

	HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

	UartHandle.Instance        = USART1;

	UartHandle.Init.BaudRate     = 9600;			//115200,9600
	UartHandle.Init.WordLength   = UART_WORDLENGTH_8B;
	UartHandle.Init.StopBits     = UART_STOPBITS_1;
	UartHandle.Init.Parity       = UART_PARITY_NONE;
	UartHandle.Init.HwFlowCtl    = UART_HWCONTROL_NONE;
	UartHandle.Init.Mode         = UART_MODE_TX_RX;
	UartHandle.Init.OverSampling = UART_OVERSAMPLING_16;
	UartHandle.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;

	if(HAL_UART_Init(&UartHandle) != HAL_OK)
	{
		while(1);
	}
}

void uart_hal_init(uart_port port)
{
	switch(port)
	{
		case UART_PORT1:
			UART1_Init();
			break;
		default:
			break;
	}
}

void uart_hal_send_byte_blocking(uart_port port, uint8_t data)
{
	switch(port)
	{
		case UART_PORT1:
			HAL_UART_Transmit(&UartHandle, &data, 1U, 10000);
			break;
		default:
			break;
	}
}

uint8_t uart_hal_get_byte_blocking(uart_port port)
{
	uint8_t ret;

	switch(port)
	{
		case UART_PORT1:
			HAL_UART_Receive(&UartHandle, &ret, 1U, 5000);
			break;
		default:
			break;
	}
}
