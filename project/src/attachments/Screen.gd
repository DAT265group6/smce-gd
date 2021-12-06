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

var body
var collision
var mesh
var material

func set_view(_view: Node) -> void:
	if ! _view:
		return
	view = _view

func _ready():

	# Create an object in the 3D world
	body = StaticBody.new()
	# Rotate and scale the object
	body.transform = body.transform.rotated(Vector3(0,1,0),PI).scaled(Vector3(1.2, 0.7, 0.1))
	# Place the object on the car
	get_parent().add_child(body)

	# Interaction with the physical world
	collision = CollisionShape.new()
	collision.shape = BoxShape.new()
	body.add_child(collision)

	# Shape appearance visually
	mesh = MeshInstance.new()
	mesh.mesh = CubeMesh.new()
	body.add_child(mesh)

	# What the shape looks like
	material = SpatialMaterial.new()
	material.albedo_color = Color(1, 1, 1)
	material.uv1_scale = Vector3(3,2,1) # 
	mesh.material_override = material

	# Run times 60 frames per second
	timer.connect("timeout", self, "_on_frame")
	add_child(timer)
	timer.start(1.0 / 60.0)

func _on_frame() -> void:
	if ! view || ! view.is_valid():
		return
	material.albedo_texture = create_texture()


# This method adds the attachment visualizer to the control panel
func visualize() -> Control:
	var visualizer = ScreenVisualizer.new()
	visualizer.display_node(self, "create_texture", "get_rgb888", "get_rgb565", "get_yuv")

	return visualizer

func create_texture() -> ImageTexture:
	var image = Image.new()
	if ! view.framebuffers(key).read_rgb888(image):
		return null
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.flags = 0
	return texture

func get_rgb888() -> String:
	var rgb: int = view.framebuffers(key).read_rgb888_pixel(0, 0)
	var r = (rgb >> 16) & 255
	var g = (rgb >> 8) & 255
	var b = (rgb >> 0) & 255
	return "RGB888: " + String(r) + ", " + String(g) + ", " + String(b)

func get_rgb565() -> String:
	var rgb: int = view.framebuffers(key).read_rgb565_pixel(0, 0)
	var r = (rgb >> 16) & 255
	var g = (rgb >> 8) & 255
	var b = (rgb >> 0) & 255
	return "RGB565: " + String(r) + ", " + String(g) + ", " + String(b)

func get_yuv() -> String:
	var yuv: int = view.framebuffers(key).read_yuv422_pixel(0, 0)
	var y = (yuv >> 16) & 255
	var u = (yuv >> 8) & 255
	var v = (yuv >> 0) & 255
	return "YUV: " + String(y) + ", " + String(u) + ", " + String(v)
