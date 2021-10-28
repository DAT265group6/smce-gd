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
		print("Custom user directory set")
		if !Global.set_user_dir(custom_dir):
			return _error("Failed to setup custom user directory")
	
	_button.connect("pressed", self, "_on_clipboard_copy")
	print("Reading version file..")
	var file = File.new()
	var version = "unknown"
	var exec_path = OS.get_executable_path()
	if file.open("res://share/version.txt", File.READ) == OK:
		version = file.get_as_text()
		file.close()

	Global.version = version

	OS.set_window_title("SMCE-gd: %s" % version)
	print("Version: %s" % version)
	print("Executable: %s" % exec_path)
	print("Mode: %s" % "Debug" if OS.is_debug_build() else "Release")
	print("User dir: %s" % Global.user_dir)
	print()
	
	var dir = Directory.new()
	
	if dir.open("res://share/RtResources") != OK:
		return _error("Internal RtResources not found!")
	
	if ! Util.copy_dir("res://share/RtResources", Global.usr_dir_plus("RtResources")):
		return _error("Failed to copy in RtResources")
	
	if ! Util.copy_dir("res://share/library_patches", Global.usr_dir_plus("library_patches")):
		return _error("Failed to copy in library_patches")
	
	Util.mkdir(Global.usr_dir_plus("mods"))
	Util.mkdir(Global.usr_dir_plus("config/profiles"), true)
	
	print("Copied RtResources")

	var bar = Toolchain.new()
	if ! is_instance_valid(bar):
		return _error("Shared library not loaded")
	
	var res = bar.init(Global.user_dir)
	
	if ! res.ok():
		var cmake_exec = yield(_download_cmake(), "completed")
		if ! cmake_exec:
			return _error("Failed to retrieve cmake")
	print(bar.resource_dir())
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

func _get_cmake_folders(path: String):
	var files = []
	var dir = Directory.new()
	dir.open(path)
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

# Manually update value of this variable to download the CMake version that you wish
# Ideally pick one version that is higher version than the minimum required version
var cmake_version = "3.21.3"

# ccrv: Current CMake Required Version
var ccrv = "3.12"

var cmake_version_name = "cmake-" + cmake_version + "-"
var cmake_os = ["linux-x86_64", "macos-universal", "windows-x86_64"]
var osi = {
	"X11": [cmake_version_name + cmake_os[0] +".tar.gz", cmake_version_name + cmake_os[0] +"/bin", "/cmake"],
	"OSX": [cmake_version_name + cmake_os[1] + ".tar.gz", cmake_version_name + cmake_os[1] + "/CMake.app/Contents/bin", "/cmake"],
	"Windows": [cmake_version_name + cmake_os[2] + ".zip", cmake_version_name + cmake_os[2] + "/bin", "/cmake.exe"]
}

func _download_cmake():
	yield(get_tree(), "idle_frame")

	var da = osi.get(OS.get_name())
	var cmake_path: String = OS.get_user_data_dir() + "/RtResources/CMake/"
	var cmake_zip: String = cmake_path + da[0]
	var cmake_exec: String = cmake_path + da[1] + da[2]
	var cmake_ver = []

	# Check if CMake with the version cmake_version is already downloaded or not
	if File.new().file_exists(cmake_exec):
		if OS.execute(cmake_exec, ["--version"], true, cmake_ver) != 0:
			return false
		print("CMake executable found on host!")
	
	# Check if CMake with any version exists on the host or not
	var cmake_folders = _get_cmake_folders(cmake_path)
	if cmake_folders.size() > 0:
		print("Finding highest CMake version found on host...")
		# cchvd: Current CMake Highest Version Directory (found on host)
		# E.g. "cmake-3.21.3-windows-x86_64"
		var cchvd

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
		cchvd = cmake_folders[0]
		cchvs = cchvd.split("-")
		cchvs = cchvs[1]

		# ccvd: Current CMake Version Directory (found on host)
		# E.g. "cmake-3.8.2-win64-x64"
		for ccvd in cmake_folders:
			# ccvs: Current CMake Version String (found on host)
			# E.g. "3.8.2"
			var ccvs
			ccvs = ccvd.split("-")
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
			# Updates cchvd and cchvs
			while true:
				if i <= ccvs_arr.size() - 1:
					if int(ccvs_arr[i]) == int(cchvs_arr[j]):
						i = i + 1
						j = j + 1
						continue
					if int(ccvs_arr[i]) > int(cchvs_arr[j]):
						cchvd = ccvd
						cchvs = ccvs
						break
					elif int(ccvs_arr[i]) < int(cchvs_arr[j]):
						break
				else:
					break

		var ccrv_arr = ccrv.split(".")
		while true:
			if ccrv_arr.size() > cchvs_arr.size():
				cchvs_arr.append("0")
			elif ccrv_arr.size() < cchvs_arr.size():
				ccrv_arr.append("0")
			else:
				break
		
		print("Checking if highest CMake version (found on host) is more updated version than the minimum required version...")
		i = 0
		j = 0
		while true:
			if i <= ccrv_arr.size() - 1:
				if int(ccrv_arr[i]) == int(cchvs_arr[j]):
					i = i + 1
					j = j + 1
					continue
				if int(ccrv_arr[i]) > int(cchvs_arr[j]):
					print("Highest CMake version that was found on host is higher version than the minimum required CMake version!")
					# Todo: Run "cmake --version" for confirmation
					break
				elif int(ccrv_arr[i]) < int(cchvs_arr[j]):
					print("Highest CMake version that was found on host is lower version than the minimum required CMake version!")
					# Todo: Upgrade cmake version (download)
					#		Run "cmake --version" for confirmation
					break
			else:
				break


	else:
		if ! File.new().file_exists(cmake_zip):
			print("Downloading CMake zip...")
			_request.download_file = cmake_zip + ".download"
			if ! _request.request("https://github.com/Kitware/CMake/releases/download/v" + cmake_version + "/%s" % da[0]):
				var ret = yield(_request, "request_completed")
				Directory.new().copy(_request.download_file, cmake_zip)
				Directory.new().remove(_request.download_file)
			else:
				return null
		
		print("Downloaded CMake zip")
		
		print("Unzipping CMake zip...")
		if ! Util.unzip(Util.user2abs(cmake_zip), cmake_path):
			return null
		
		print("Unzipped CMake zip")
		
		print("Delete CMake zip")
		Directory.new().remove(cmake_zip)

		if OS.execute(cmake_exec, ["--version"], true, cmake_ver) != 0:
			return false
		
		print("CMake has been downloaded and installed on host!")
	
	print("%s" % cmake_ver.front())
	return cmake_exec
