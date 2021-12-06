#include <ArduinoGraphics.h>
#include <Arduino_MKRRGB.h>

void setup() {
    MATRIX.begin();
    MATRIX.brightness(255);
}

void loop() {
    MATRIX.beginDraw();
    MATRIX.background(255, 255, 0);
    MATRIX.clear();
    MATRIX.set(3, 1, 255, 0, 0);
    MATRIX.set(8, 1, 255, 0, 0);

    // MATRIX.set(5, 2, 255, 0, 0);
    // MATRIX.set(6, 2, 255, 0, 0);

    MATRIX.set(4, 4, 255, 0, 0);
    MATRIX.set(5, 4, 255, 0, 0);
    MATRIX.set(6, 4, 255, 0, 0);
    MATRIX.set(7, 4, 255, 0, 0);
    MATRIX.set(3, 5, 255, 0, 0);
    MATRIX.set(8, 5, 255, 0, 0);
    MATRIX.endDraw();
    delay(1000);

    MATRIX.beginDraw();
    MATRIX.background(0, 0, 255);
    MATRIX.clear();
    MATRIX.set(3, 1, 0, 255, 0);
    MATRIX.set(8, 1, 0, 255, 0);

    // MATRIX.set(5, 2, 255, 0, 0);
    // MATRIX.set(6, 2, 255, 0, 0);

    MATRIX.set(4, 5, 0, 255, 0);
    MATRIX.set(5, 5, 0, 255, 0);
    MATRIX.set(6, 5, 0, 255, 0);
    MATRIX.set(7, 5, 0, 255, 0);
    MATRIX.set(3, 4, 0, 255, 0);
    MATRIX.set(8, 4, 0, 255, 0);
    MATRIX.endDraw();
    delay(1000);
}
