#include <stdint.h>

// VGA text mode buffer address
volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;
// VGA colors
enum vga_color {
    BLACK,
    BLUE,
    GREEN,
    CYAN,
    RED,
    MAGENTA,
    BROWN,
    LIGHT_GREY,
    DARK_GREY,
    LIGHT_BLUE,
    LIGHT_GREEN,
    LIGHT_CYAN,
    LIGHT_RED,
    LIGHT_MAGENTA,
    LIGHT_BROWN,
    WHITE,
};

// Function to create a VGA entry
uint16_t vga_entry(unsigned char ch, uint8_t fg, uint8_t bg) {
    uint16_t fg16 = fg & 0x0F;
    uint16_t bg16 = (bg & 0x0F) << 4;
    return (bg16 | fg16) << 8 | ch;
}

// Kernel main function
void kernel_main() {
    // Clear the screen
    for (int i = 0; i < 80 * 25; i++) {
        vga_buffer[i] = vga_entry(' ', WHITE, BLACK);
    }
    
    // Display "Hello, 32 bit Kernel World!"
    const char* str = "Hello, 32 bit Kernel World!";
    int i = 0;
    int position = 80 * 10 + 25; // Middle of the screen
    
    while (str[i] != '\0') {
        vga_buffer[position + i] = vga_entry(str[i], LIGHT_GREEN, BLACK);
        i++;
    }
    
    // Halt the CPU
    while (1) {
        __asm__ volatile("hlt");
    }
}