#
#  Screen.gd
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

# TODO:
#  - Make the visualize method return a TextureRect that works
#  - Design the 3D model of the screen to be attached to the car
#  - Show the image on the screen:
#      Read from the framebuffer using read_rgb888
#      Put the image on a TextureRect

extends Node
class_name Screen

func extern_class_name():
	return "Screen"

onready var timer: Timer = Timer.new()
onready var effect = TextureRect.new()

export var key = 1

var view = null setget set_view

func set_view(_view: Node) -> void:
	if ! _view:
		return
	view = _view

func _ready():
	timer.connect("timeout", self, "_on_frame")

	timer.autostart = true
	add_child(timer)

func _on_frame() -> void:
	if ! view || ! view.is_valid():
		return

# This method adds the attachment visualizer to the control panel
func visualize() -> Control:
	var visualizer = ScreenVisualizer.new()
	visualizer.rect_min_size.x = 120
	visualizer.rect_min_size.y = 70
	visualizer.display_node(self, "create_texture")
    # This part should probably move to ScreenVisualizer class and be rethought somehow...
	visualizer.rect_scale = Vector2(10, 10)
	return visualizer

func create_texture() -> ImageTexture:
	var image = Image.new()
	if ! view.framebuffers(key).read_rgb888(image):
		return null
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	return texture
