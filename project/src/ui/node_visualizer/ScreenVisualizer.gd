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
extends TextureRect

var _node: Node = null
var _texture_func: String = ""

func display_node(node: Node, texture_func: String) -> bool:
	if ! node || ! node.has_method(texture_func):
		return false
	_node = node
	_texture_func = texture_func
	
	return true

func _process(_delta: float) -> void:
	if ! _node:
		return
	
	texture = _node.call(_texture_func)
	rect_scale = Vector2(10, 10)
