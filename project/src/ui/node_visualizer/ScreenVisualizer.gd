#
#  ScreenVisualizer.gd
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

class_name ScreenVisualizer
extends VBoxContainer

var _tr: TextureRect = null
var _label: Label = null
var _node: Node = null
var _texture_func: String = ""
var _rgb888_func: String = ""
var _rgb565_func: String = ""
var _yuv_func: String = ""
var _pick_x = 0
var _pick_y = 0

func _ready():
	rect_min_size.x = 120
	rect_min_size.y = 175

	_tr = TextureRect.new()
	_tr.rect_min_size.x = 120
	_tr.rect_min_size.y = 70
	add_child(_tr)

	_label = Label.new()
	add_child(_label)

func display_node(node: Node, texture_func: String, rgb888_func: String, rgb565_func: String, yuv_func: String) -> bool:
	if ! node || ! node.has_method(texture_func):
		return false
	_node = node
	_texture_func = texture_func
	_rgb888_func = rgb888_func
	_rgb565_func = rgb565_func
	_yuv_func = yuv_func
	
	return true

func _process(_delta: float) -> void:
	if ! _node:
		return
	
	_tr.texture = _node.call(_texture_func)
	_tr.stretch_mode = 5
	_tr.expand = true

	_label.text = "Pixel (" + String(_pick_x) + ", " + String(_pick_y) + ")\n" + _node.call(_rgb888_func) + "\n" + _node.call(_rgb565_func) + "\n" + _node.call(_yuv_func)
