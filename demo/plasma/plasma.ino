#include <ArduinoGraphics.h>
#include <Arduino_MKRRGB.h>
#include <Smartcar.h>

ArduinoRuntime arduinoRuntime;
BrushedMotor leftMotor(arduinoRuntime, smartcarlib::pins::v2::leftMotorPins);
BrushedMotor rightMotor(arduinoRuntime, smartcarlib::pins::v2::rightMotorPins);
DifferentialControl control(leftMotor, rightMotor);
SimpleCar car(control);

double time = 0.0;

void setup() {
  MATRIX.begin();
  // Drive the car forward, turning slightly to the left
  car.setSpeed(20);
  car.setAngle(-15);
  MATRIX.brightness(255);
}

void loop() {
  time += 0.01;
  double tt = sin(time) * 10.0;

  MATRIX.beginDraw();
  for (int y = 0; y < 7; y++) {
    double yy = y * 0.1;
    for (int x = 0; x < 12; x++) {
      double xx = x * 0.1;
      double td1 = sin(time + y * 0.01);
      double td2 = sin(time * 1.3 - x * 0.01 + 0.5);
      double td3 = sin(time * 0.7 + x * 0.015 - y * 0.02 + 1.0);
      double td4 = sin(time * 1.1 - x * 0.02 + y * 0.03 + 1.5);
      double td5 = sin(time * 0.9 + x * 0.03 + y * 0.04 + 2.0);
      double td6 = sin(time * 1.2 - x * 0.04 - y * 0.05 + 2.5);
      double rawR = sin(xx * td1 + yy * td2 + tt * td3 + td4);
      double rawG = sin(xx * td2 + yy * td3 + tt * td4 + td5);
      double rawB = sin(xx * td3 + yy * td4 + tt * td5 + td6);
      uint8_t r = (uint8_t)(rawR * 127.0 + 127.0);
      uint8_t g = (uint8_t)(rawG * 127.0 + 127.0);
      uint8_t b = (uint8_t)(rawB * 127.0 + 127.0);
      MATRIX.set(x, y, r, g, b);
    }
  }

  int textX = 12 - (int)(time * 25) % 120;
  MATRIX.stroke(255, 255, 255);
  MATRIX.text("Group 6!", textX, 0);

  MATRIX.endDraw();

  delay(15);
}
