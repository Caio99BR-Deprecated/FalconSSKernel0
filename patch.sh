#!/bin/bash
# Writen by Caio Oliveira aka Caio99BR <caiooliveirafarias0@gmail.com>

echo "  | Live Git Patcher"

# Check option of user and transform to script
for _u2t in "${@}"
do
	if [[ "${_u2t}" == "-h" || "${_u2t}" == "--help" ]]
	then
		echo "  |"
		echo "  | Put the link after '. patch.sh'"
		echo "  | To use this script"
		echo "  |"
		echo "  | Options:"
		echo "  | -h    | --help  | To show this message"
		echo "  | -caf  | --caf   | Bypass addition of '.patch' in links"
		echo "  | -3    | --3     | Use 'git am -3' to apply patchs"
	fi
	if [[ "${_u2t}" == "-caf" || "${_u2t}" == "--caf" ]]
	then
		_option_caf="enable"
	fi
	if [[ "${_u2t}" == "-3" || "${_u2t}" == "--3" ]]
	then
		_option_am3=" -3"
	fi
done

echo "  |"
echo "  | Number of patch's: ${#}"

c="0"
for link in ${@}
do
	if [[ "${link}" == "http"* ]]
	then
		c=$[$c+1]
		echo "  |"
		echo "  | Patch #${c}"
		if [[ "${link}" == *".patch" || "${_option_caf}" == "enable" ]]
		then
			nl="${link}"
		else
			nl="${link}.patch"
		fi
		patch_filename="patch.sh-${c}.patch"
		path_patch="/tmp"
		echo "  |"
		echo "  | Downloading"
		curl -# -o ${path_patch}/${patch_filename} ${nl}
		if [ -f "${path_patch}/${patch_filename}" ]
		then
			echo "  |"
			echo "  | Patching"
			git am${_option_am3} ${path_patch}/${patch_filename}
			if [ "${?}" == "0" ]
			then
				echo "  |"
				echo "  | Patch (${c}/${#})"
			else
				echo "  |"
				echo "  | Something not worked good in patch #${c}"
				echo "  | Aborting 'git am' process"
				if ! [ "${c}" == "${#}" ]
				then
					if [ ${#} -gt "1" ]; then
						echo "  |"
						echo "  | Passing to next patch"
					fi
				fi
				echo $(tput sgr0)
				git am --abort
			fi
		else
			echo "  |"
			echo "  | Patch not downloaded, check internet or link"
			if ! [ "${c}" == "${#}" ]
			then
				if [ ${#} -gt "1" ]; then
					echo "  |"
					echo "  | Passing to next patch"
				fi
			fi
		fi
		rm -rf ${path_patch}/${patch_filename}
	else
		if [[ "${link}" == "--caf" || "${_option_caf}" == "-caf" ]]
		then
			# WORKAROUND
			echo > /dev/null
		elif [[ "${link}" == "--3" || "${_option_caf}" == "-3" ]]
		then
			# WORKAROUND
			echo > /dev/null
		else
			echo "  |"
			echo "  | This link:"
			echo "  | ${link}"
			echo "  | not is a 'HTTP' link"
			echo "  | This script only accept 'HTTP' links for now"
			if ! [ "${c}" == "${#}" ]
			then
				if [ ${#} -gt "1" ]; then
					echo "  |"
					echo "  | Passing to next patch"
				fi
			fi
		fi
	fi
done

unset _option_caf _option_am3
