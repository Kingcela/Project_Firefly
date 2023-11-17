#include "alt_types.h"

#define BUTTONPRESSED		0
#define BUTTONRELEASED		1

int main()
{
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the PIO block
	volatile unsigned int *SWITCHES_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *ACCUMULATE_PIO = (unsigned int*)0x50; //make a pointer to access the PIO block

	// Clear All LEDs
	*LED_PIO = 0;

	int accumulate_pressed = BUTTONRELEASED;
	while (1)
	{
		// Button Got Pressed
		if (accumulate_pressed == BUTTONRELEASED && *ACCUMULATE_PIO == BUTTONPRESSED) {
			accumulate_pressed = BUTTONPRESSED;
			*LED_PIO += *SWITCHES_PIO;
		}
		// Button Lifted
		if (accumulate_pressed == BUTTONPRESSED && *ACCUMULATE_PIO == BUTTONRELEASED) {
			accumulate_pressed = BUTTONRELEASED;
		}
	}

	return 1;
}
