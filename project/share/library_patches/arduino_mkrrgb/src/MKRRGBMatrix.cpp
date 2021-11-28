/*
 *  MKRRGBMatrix.cpp
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

#include <fstream>
#include <iostream>
#include "MKRRGBMatrix.h"

RGBMatrixClass::RGBMatrixClass() : ArduinoGraphics(RGB_MATRIX_WIDTH, RGB_MATRIX_HEIGHT) {}

RGBMatrixClass::~RGBMatrixClass() {}

int RGBMatrixClass::begin() {
    if (!ArduinoGraphics::begin()) {
        return 0;
    }

    textFont(Font_5x7);

    brightness(127);

    return inner.begin();
}

void RGBMatrixClass::end() {
    ArduinoGraphics::end();

    inner.end();
}

void RGBMatrixClass::brightness(uint8_t brightness) { inner.brightness(brightness); }

void RGBMatrixClass::beginDraw() {
    ArduinoGraphics::beginDraw();
    inner.beginDraw();
}

void RGBMatrixClass::endDraw() {
    ArduinoGraphics::endDraw();
    inner.endDraw();
}

void RGBMatrixClass::set(int x, int y, uint8_t r, uint8_t g, uint8_t b) { inner.set(x, y, r, g, b); }

RGBMatrixClass MATRIX;
