/**
 * @file main.h
 * @author Max Ma (maxma2@illinois.edu), Dhruv Kulgod (dkulgod2@illinois.edu)
 * @brief Quality of Life Declarations
 * @version 1.0
 * @date 2023-03-14
 * 
 * @copyright Copyright (c) 2023
 * 
 */

// Main Memory
#define KEYCODE_BASE            0x8002000

// Memory Mapped IO
#define KEYCODE_PIO_BASE        0x00000150
#define USB_IRQ_PIO_BASE        0x00000160
#define USB_GPX_PIO_BASE        0x00000170
#define USB_RST_PIO_BASE        0x00000180
#define HEX_DIGITS_PIO_BASE     0x00000190
#define LEDS_PIO_BASE           0x000001A0
#define KEY_PIO_BASE            0x000001B0

// Interrupt Table
#define JTAG_UART_IRQ           1U
#define TIMER_IRQ               2U
#define SPI_IRQ                 3U
