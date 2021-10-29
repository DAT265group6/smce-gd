#
#  Entry.gd
#  Copyright 2021 ItJustWorksTM
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

extends Node

export var main_scene: PackedScene = null

onready var _header: Label = $Header
onready var _log: RichTextLabel = $Log
onready var _button: Button = $Button
onready var _request: HTTPRequest = $HTTPRequest

var error: String = ""

func _ready():
	var custom_dir = OS.get_environment("SMCEGD_USER_DIR")
	if custom_dir != "":
		#print("Custom user directory set")
		if !Global.set_user_dir(custom_dir):
			return _error("Failed to setup custom user directory")
	
	_button.connect("pressed", self, "_on_clipboard_copy")
	#print("Reading version file..")
	var file = File.new()
	var version = "unknown"
	var exec_path = OS.get_executable_path()
	if file.open("res://share/version.txt", File.READ) == OK:
		version = file.get_as_text()
		file.close()

	Global.version = version

	OS.set_window_title("SMCE-gd: %s" % version)
	#print("Version: %s" % version)
	#print("Executable: %s" % exec_path)
	#print("Mode: %s" % "Debug" if OS.is_debug_build() else "Release")
	#print("User dir: %s" % Global.user_dir)
	#print()
	
	var dir = Directory.new()
	
	if dir.open("res://share/RtResources") != OK:
		return _error("Internal RtResources not found!")
	
	if ! Util.copy_dir("res://share/RtResources", Global.usr_dir_plus("RtResources")):
		return _error("Failed to copy in RtResources")
	
	if ! Util.copy_dir("res://share/library_patches", Global.usr_dir_plus("library_patches")):
		return _error("Failed to copy in library_patches")
	
	Util.mkdir(Global.usr_dir_plus("mods"))
	Util.mkdir(Global.usr_dir_plus("config/profiles"), true)

	var bar = Toolchain.new()
	if ! is_instance_valid(bar):
		return _error("Shared library not loaded")
	
	var res = bar.init(Global.user_dir)
	if ! res.ok():
		if ! yield(_auto_install_cmake(), "completed"):
			return _error("Failed to retrieve cmake")
	#print(bar.resource_dir())
	bar.free()

	Global.scan_named_classes("res://src")
	
	# somehow destroys res://
	ModManager.load_mods()
	
	_continue()

func _continue():
	if ! main_scene:
		return _error("No Main Scene")
	get_tree().change_scene_to(main_scene)

func _error(message: String) -> void:
	var file: File = File.new()
	var result = file.open("user://logs/godot.log", File.READ)
	var logfile = file.get_as_text()
	file.close()

	_log.text = logfile
	_header.text += "\n" + message
	error = "Error Reason: " + message + "\n" + logfile

func _on_clipboard_copy() -> void:
	OS.clipboard = error

# CMake version to be downloaded and installed
var cmake_version = "3.21.3"

# Minimum CMake version required
var cmake_minimum_version = "3.12"

var osi = {
	"X11": ["linux-x86_64", ".tar.gz", "/bin", "/cmake"],
	"OSX": ["macos-universal", ".tar.gz", "/CMake.app/Contents/bin", "/cmake"],
	"Windows": ["windows-x86_64", ".zip", "/bin", "/cmake.exe"]
}
var da = osi.get(OS.get_name())
var cmake_path: String = OS.get_user_data_dir() + "/RtResources/CMake/"
var cmake_exec_paths = []
var cmake_urls = []

# For searching CMake execution path
func _update_cmake_exec_paths(v: String) -> void:
	cmake_exec_paths = []
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + da[0] + "/" + "cmake-" + cmake_version + "-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc1-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc2-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc3-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc4-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc5-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc1-" + da[0] + "/" + "cmake-" + cmake_version + "-" + "rc1-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc2-" + da[0] + "/" + "cmake-" + cmake_version + "-" + "rc2-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc3-" + da[0] + "/" + "cmake-" + cmake_version + "-" + "rc3-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc4-" + da[0] + "/" + "cmake-" + cmake_version + "-" + "rc4-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + cmake_version + "-" + "rc5-" + da[0] + "/" + "cmake-" + cmake_version + "-" + "rc5-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + da[0] + "/" + "cmake-" + cmake_version + "-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc1-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc2-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc3-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc4-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc5-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc1-" + da[0] + "/" + "cmake-" + "v" + cmake_version + "-" + "rc1-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc2-" + da[0] + "/" + "cmake-" + "v" + cmake_version + "-" + "rc2-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc3-" + da[0] + "/" + "cmake-" + "v" + cmake_version + "-" + "rc3-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc4-" + da[0] + "/" + "cmake-" + "v" + cmake_version + "-" + "rc4-" + da[0] + da[2] + da[3])
	cmake_exec_paths.append(cmake_path + "cmake-" + "v" + cmake_version + "-" + "rc5-" + da[0] + "/" + "cmake-" + "v" + cmake_version + "-" + "rc5-" + da[0] + da[2] + da[3])

# For searching CMake download url
func _update_cmake_urls(v: String) -> void:
	var gh = "https://github.com/Kitware/CMake/releases/download/"
	cmake_urls = []
	cmake_urls.append(gh + "v" + cmake_version + "/%s" % ("cmake-" + cmake_version + "-" + da[0] + da[1]))
	cmake_urls.append(gh + "v" + cmake_version + "-" + "rc5" + "/%s" % ("cmake-" + cmake_version + "-" + "rc5" + "-" + da[0] + da[1]))
	cmake_urls.append(gh + "v" + cmake_version + "-" + "rc4" + "/%s" % ("cmake-" + cmake_version + "-" + "rc4" + "-" + da[0] + da[1]))
	cmake_urls.append(gh + "v" + cmake_version + "-" + "rc3" + "/%s" % ("cmake-" + cmake_version + "-" + "rc3" + "-" + da[0] + da[1]))
	cmake_urls.append(gh + "v" + cmake_version + "-" + "rc2" + "/%s" % ("cmake-" + cmake_version + "-" + "rc2" + "-" + da[0] + da[1]))
	cmake_urls.append(gh + "v" + cmake_version + "-" + "rc1" + "/%s" % ("cmake-" + cmake_version + "-" + "rc1" + "-" + da[0] + da[1]))

func _get_cmake_folders():
	var files = []
	var dir = Directory.new()
	dir.open(cmake_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file != "":
			if file == "." or file == "..":
				continue
			if "cmake" in file:
				files.append(file)
		else:
			break
	
	dir.list_dir_end()
	return files

func _check_cmake_version() -> bool:
	# Check if CMake with the version cmake_version is already downloaded or not
	_update_cmake_exec_paths(cmake_version)
	for exec in cmake_exec_paths:
		if File.new().file_exists(exec):
			if OS.execute(exec, ["--version"], true) == 0:
				return true
	
	# Check if CMake with any version exists on the host or not
	var cmake_folders = _get_cmake_folders()
	if cmake_folders.size() > 0:
		print("Searching for CMake...")
		# cchvp: Current CMake Highest Version Path (found on host)
		# E.g. "cmake-3.21.3-windows-x86_64"
		var cchvp

		# cchvs: Current CMake Highest Version String (found on host)
		# E.g. "3.21.3"
		var cchvs

		# ccvs_arr: ccvs array
		# E.g. [3, 8, 2]
		# cchvs_arr: cchvs array
		# E.g. [3, 21, 3]
		var ccvs_arr
		var cchvs_arr

		# Index for ccvs_arr/ccrv_arr
		var i

		# Index for cchvs_arr
		var j

		# Initialize variables
		cchvp = cmake_folders[0]
		cchvs = cchvp.split("-")
		cchvs = cchvs[1]

		# ccvp: Current CMake Version Path (found on host)
		# E.g. "cmake-3.8.2-win64-x64"
		for ccvp in cmake_folders:
			# ccvs: Current CMake Version String (found on host)
			# E.g. "3.8.2"
			var ccvs
			ccvs = ccvp.split("-")
			ccvs = ccvs[1]

			# ccvs_arr: ccvs array
			# E.g. [3, 8, 2]
			# cchvs_arr: cchvs array
			# E.g. [3, 21, 3]
			ccvs_arr = ccvs.split(".")
			cchvs_arr = cchvs.split(".")
			
			# Making sure both ccvs_arr and cchvs_arr has the same array size
			# E.g.
			#	if cchvs_arr is [3, 21] and ccvs_arr is [3, 8, 2] then:
			# 		append cchvs_arr to make it [3, 21, 0] so both arrays have equal size, vice versa
			while true:
				if ccvs_arr.size() > cchvs_arr.size():
					cchvs_arr.append("0")
				elif ccvs_arr.size() < cchvs_arr.size():
					ccvs_arr.append("0")
				else:
					break
			
			i = 0
			j = 0

			# Comparing to find CMake Highest Version (found on host)
			# Updates cchvp and cchvs
			while true:
				if i <= ccvs_arr.size() - 1:
					if int(ccvs_arr[i]) == int(cchvs_arr[j]):
						i = i + 1
						j = j + 1
						continue
					if int(ccvs_arr[i]) > int(cchvs_arr[j]):
						cchvp = ccvp
						cchvs = ccvs
						break
					elif int(ccvs_arr[i]) < int(cchvs_arr[j]):
						break
				else:
					break
		
		# ccrv: Current CMake Required Version
		# E.g. "3.12"
		var ccrv = cmake_minimum_version

		# ccrv_arr: cchr array
		# E.g. [3, 12]
		var ccrv_arr = ccrv.split(".")

		while true:
			if ccrv_arr.size() > cchvs_arr.size():
				cchvs_arr.append("0")
			elif ccrv_arr.size() < cchvs_arr.size():
				ccrv_arr.append("0")
			else:
				break
		
		print("Comparing CMake versions...")
		i = 0
		j = 0
		while true:
			if i <= ccrv_arr.size() - 1:
				if int(ccrv_arr[i]) == int(cchvs_arr[j]):
					i = i + 1
					j = j + 1
					continue
				if int(ccrv_arr[i]) < int(cchvs_arr[j]):
					print("Current CMake version higher than minimum required version")
					var arr = [cmake_path + cchvp + da[2] + da[3], cmake_path + cchvp + "/" + cchvp + da[2] + da[3]]
					for a in arr:
						if OS.execute(a, ["--version"], true) == 0:
							print("CMake exe found")
							return true
					return false
				elif int(ccrv_arr[i]) > int(cchvs_arr[j]):
					print("Current CMake version lower than minimum required version")
					return false
			else:
				break
	return false

func _download_install_cmake() -> bool:
	yield(get_tree(), "idle_frame")

	var temp_cmake = "temp_cmake"

	var cmake_zip
	var url_found = false

	if ! File.new().file_exists(temp_cmake):
		_request.download_file = temp_cmake + ".download"

		_update_cmake_urls(cmake_version)
		for url in cmake_urls:
			if ! _request.request(url):
				var ret = yield(_request, "request_completed")
				if ret[1] == 200:
					print("Download CMake...")
					var x = url
					x = x.split("/")
					x = x[x.size()-1]

					cmake_zip = cmake_path + x
					url_found = true
				elif ret[1] == 404:
					continue
				Directory.new().copy(_request.download_file, cmake_zip)
				Directory.new().remove(_request.download_file)
				if url_found:
					break
			else:
				return false
	
	if !url_found:
		print("CMake version cmake_version not found / Incorrect URL")
		return false

	print("Unzip CMake...")
	if ! Util.unzip(Util.user2abs(cmake_zip), cmake_path):
		return false
	
	Directory.new().remove(cmake_zip)
	
	var exec_found = false
	_update_cmake_exec_paths(cmake_version)
	for exec in cmake_exec_paths:
		if OS.execute(exec, ["--version"], true) == 0:
			exec_found = true
			break
	
	if !exec_found:
		return false
	
	print("CMake has been downloaded and installed!")
	return true

func _auto_install_cmake() -> bool:
	yield(get_tree(), "idle_frame")

	if _check_cmake_version():
		return true
	
	if yield(_download_install_cmake(), "completed"):
		return true
	return false
