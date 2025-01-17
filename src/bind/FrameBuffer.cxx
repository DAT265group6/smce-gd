/*
 *  FrameBuffer.cxx
 *  Copyright 2021 ItJustWorksTM
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

#include <span>
#include <vector>
#include "bind/FrameBuffer.hxx"

using namespace godot;

void FrameBuffer::_register_methods() {
    register_method("exists", &FrameBuffer::exists);
    register_method("needs_horizontal_flip", &FrameBuffer::needs_horizontal_flip);
    register_method("needs_vertical_flip", &FrameBuffer::needs_vertical_flip);
    register_method("get_width", &FrameBuffer::get_width);
    register_method("get_height", &FrameBuffer::get_height);
    register_method("get_freq", &FrameBuffer::get_freq);
    register_method("write_rgb888", &FrameBuffer::write_rgb888);
    register_method("read_rgb888", &FrameBuffer::read_rgb888);
    register_method("read_rgb888_pixel", &FrameBuffer::read_rgb888_pixel);
    register_method("read_rgb565_pixel", &FrameBuffer::read_rgb565_pixel);
    register_method("read_yuv422_pixel", &FrameBuffer::read_yuv422_pixel);
}

bool FrameBuffer::exists() { return frame_buf.exists(); }
bool FrameBuffer::needs_horizontal_flip() noexcept { return frame_buf.needs_vertical_flip(); }
bool FrameBuffer::needs_vertical_flip() noexcept { return frame_buf.needs_horizontal_flip(); }
int FrameBuffer::get_width() noexcept { return frame_buf.get_width(); }
int FrameBuffer::get_height() noexcept { return frame_buf.get_height(); }
int FrameBuffer::get_freq() noexcept { return frame_buf.get_freq(); }

bool FrameBuffer::write_rgb888(Ref<Image> img) {
    img->convert(Image::Format::FORMAT_RGB8);
    auto bytes = img->get_data();

    if (bytes.size() <= 0)
        return false;

    const auto byte_span =
        std::span{reinterpret_cast<const std::byte*>(bytes.read().ptr()), static_cast<size_t>(bytes.size())};

    return frame_buf.write_rgb888(byte_span);
}

bool FrameBuffer::read_rgb888(Ref<Image> img) {
    // If the frame buffer hasn't yet been configured, return false
    if (!frame_buf.exists())
        return false;
    if (frame_buf.get_width() == 0)
        return false;

    // Reserve space for Width * Height * 3 bytes
    const std::size_t array_size = get_width() * get_height() * 3;
    std::vector<std::byte> byte_span(array_size);

    // Read RGB888 values from the frame buffer
    if (!frame_buf.read_rgb888(byte_span))
        return false;

    // Create a PoolByteArray https://docs.godotengine.org/en/stable/classes/class_poolbytearray.html
    godot::PoolByteArray pool;
    // Give it the right size
    pool.resize(array_size);

    // Copy the RGB888 values from the C++ array to the Godot PoolByteArray
    for (std::size_t i = 0; i < array_size; i++) {
        pool.set(i, (uint8_t)byte_span[i]);
    }

    // Create an Image object from the copied image
    img->create_from_data(get_width(), get_height(), false, Image::Format::FORMAT_RGB8, pool);

    return true;
}

// Reads one pixel from the framebuffer and returns a 32-bit integer:
// R << 16  |  G << 8  |  B << 0
int FrameBuffer::read_rgb888_pixel(int x, int y) {
    // If the frame buffer hasn't yet been configured, return false
    if (!frame_buf.exists())
        return 0;
    if (frame_buf.get_width() == 0)
        return 0;

    // Reserve space for Width * Height * 3 bytes
    const std::size_t array_size = get_width() * get_height() * 3;
    std::vector<std::byte> byte_span(array_size);

    // Read RGB888 values from the frame buffer
    if (!frame_buf.read_rgb888(byte_span))
        return 0;

    // TODO: Use x, y
    int r = (int)byte_span[0];
    int g = (int)byte_span[1];
    int b = (int)byte_span[2];

    return (r << 16) | (g << 8) | (b << 0);
}

// Reads one pixel from the framebuffer and returns a 32-bit integer:
// R << 16  |  G << 8  |  B << 0
int FrameBuffer::read_rgb565_pixel(int x, int y) {
    // If the frame buffer hasn't yet been configured, return false
    if (!frame_buf.exists())
        return 0;
    if (frame_buf.get_width() == 0)
        return 0;

    // Reserve space for Width * Height * 3 bytes
    const std::size_t array_size = get_width() * get_height() * 2;
    std::vector<std::byte> byte_span(array_size);

    // Read RGB888 values from the frame buffer
    if (!frame_buf.read_rgb565(byte_span))
        return 0;

    // TODO: Use x, y
    int r = (int)(((byte_span[1] & (std::byte)0b11111000)) >> 3);
    int g = (int)(((byte_span[1] & (std::byte)0b00000111)) << 3) |
            (int)(((byte_span[0] & (std::byte)0b11100000)) >> 5);
    int b = (int)(byte_span[0] & (std::byte)0b00011111);

    return (r << 16) | (g << 8) | (b << 0);
}

// Reads one pixel from the framebuffer and returns a 32-bit integer:
// Y << 16  |  U << 8  |  V << 0
int FrameBuffer::read_yuv422_pixel(int x, int y) {
    // If the frame buffer hasn't yet been configured, return false
    if (!frame_buf.exists())
        return 0;
    if (frame_buf.get_width() == 0)
        return 0;

    // Reserve space for Width * Height * 2 bytes
    const std::size_t array_size = get_width() * get_height() * 2;
    std::vector<std::byte> byte_span(array_size);

    // Read YUV422 values from the frame buffer
    if (!frame_buf.read_yuv422(byte_span))
        return 0;

    // TODO: Use x, y
    int y1 = (int)byte_span[0];
    int u = (int)byte_span[1];
    int v = (int)byte_span[3];

    return (y1 << 16) | (u << 8) | (v << 0);
}
