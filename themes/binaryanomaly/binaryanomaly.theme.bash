# shellcheck shell=bash

# Detect whether a reboot is required
function show_reboot_required() {
	if [ -n "$_bf_prompt_reboot_info" ]; then
		if [ -f /var/run/reboot-required ]; then
			printf "Reboot required!"
		fi
	fi
}

# Set different host color for local and remote sessions
function set_host_color() {
	# Detect if connection is through SSH
	if [[ -n $SSH_CLIENT ]]; then
		printf '%s' "${lime_yellow}"
	else
		printf '%s' "${light_orange}"
	fi
}

# Set different username color for users and root
function set_user_color() {
	case $(id -u) in
		0)
			printf '%s' "${red}"
			;;
		*)
			printf '%s' "${cyan}"
			;;
	esac
}

# Define custom colors we need
# non-printable bytes in PS1 need to be contained within \[ \].
# Otherwise, bash will count them in the length of the prompt
function set_custom_colors() {
	dark_grey="\[$(tput setaf 8)\]"
	light_grey="\[$(tput setaf 248)\]"

	light_orange="\[$(tput setaf 172)\]"
	bright_yellow="\[$(tput setaf 220)\]"
	lime_yellow="\[$(tput setaf 190)\]"

	powder_blue="\[$(tput setaf 153)\]"
}

__ps_time() {
	printf '%s' "$(clock_prompt)${normal}\n"
}

function prompt_command() {
	ps_reboot="${bright_yellow}$(show_reboot_required)${normal}\n"

	ps_username="$(set_user_color)\u${normal}"
	ps_uh_separator="${dark_grey}@${normal}"
	ps_hostname="$(set_host_color)\h${normal}"

	ps_path="${yellow}\w${normal}"
	ps_scm_prompt="${light_grey}$(scm_prompt)"

	ps_user_mark="${normal} ${normal}"
	ps_user_input="${normal}"

	# Set prompt
	PS1="$ps_reboot$(__ps_time)$ps_username$ps_uh_separator$ps_hostname $ps_path $ps_scm_prompt$ps_user_mark$ps_user_input"
}

# Initialize custom colors
set_custom_colors

THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$dark_grey"}

# scm theming
SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${light_grey}"
SCM_THEME_PROMPT_CLEAN=" ${green}✓${light_grey}"
SCM_GIT_CHAR="${green}±${light_grey}"
SCM_SVN_CHAR="${bold_cyan}⑆${light_grey}"
SCM_HG_CHAR="${bold_red}☿${light_grey}"

safe_append_prompt_command prompt_command
