/*
  This file is part of the Arduino_MKRRGB library.
  Copyright (c) 2019 Arduino SA. All rights reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef _MKR_RGB_MATRIX_H
#define _MKR_RGB_MATRIX_H

#include <ArduinoGraphics.h>
#include <MkrRgb.h>

#define RGB_MATRIX_WIDTH 12
#define RGB_MATRIX_HEIGHT 7

class RGBMatrixClass : public ArduinoGraphics {
  public:
    RGBMatrixClass();
    virtual ~RGBMatrixClass();

    int begin();
    void end();

    void brightness(uint8_t brightness);

    virtual void beginDraw();
    virtual void endDraw();

    virtual void set(int x, int y, uint8_t r, uint8_t g, uint8_t b);

  private:
    MkrRgb inner;
};

extern "C" RGBMatrixClass MATRIX;

#endif
