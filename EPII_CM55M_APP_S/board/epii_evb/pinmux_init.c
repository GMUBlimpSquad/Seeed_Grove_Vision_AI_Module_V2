/*
 * pinmux_init.c
 *
 *  Created on: 2023�~9��8��
 *      Author: 902447
 */


#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "WE2_device.h"

#ifdef IP_scu
#include "hx_drv_scu.h"
#endif
#include "pinmux_init.h"

void __attribute__((weak)) pinmux_init()
{
	SCU_PINMUX_CFG_T pinmux_cfg;

	hx_drv_scu_get_all_pinmux_cfg(&pinmux_cfg);
	/*Change UART0 pin mux to PB0 and PB1*/
	pinmux_cfg.pin_pb0 = SCU_PB0_PINMUX_UART0_RX_1;   /*!< pin PB0*/
	pinmux_cfg.pin_pb1 = SCU_PB1_PINMUX_UART0_TX_1;   /*!< pin PB1*/

	pinmux_cfg.pin_pb6 = SCU_PB6_PINMUX_UART1_RX;   /*!< pin PB6*/
	pinmux_cfg.pin_pb7 = SCU_PB7_PINMUX_UART1_TX;   /*!< pin PB7*/

	pinmux_cfg.pin_pa2 = SCU_PA2_PINMUX_SB_I2C_S_SCL_0;   /*!< pin PB6*/
	pinmux_cfg.pin_pa3 = SCU_PA3_PINMUX_SB_I2C_S_SDA_0;;   /*!< pin PB7*/


	hx_drv_scu_set_all_pinmux_cfg(&pinmux_cfg, 1);
}
