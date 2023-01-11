#!/usr/bin/env bash
###############################################################################
#   demo.sh
#      it's a part of the rpmrebuild project
#
#    Copyright (C) 2004 by Eric Gerbier
#    Bug reports to: eric.gerbier@tutanota.com
#      or	   : valery_reznic@users.sourceforge.net
#    $Id$
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
###############################################################################
# code's file of demo plugin for rpmrebuild

version=1.2
###############################################################################
function msg () {
	echo >&2 $*
}
###############################################################################
function syntaxe () {
	msg "this plugin just show which spec part is changed by a plugin"
	msg "it must be called with a change-spec* option"
	msg "-n|--null : does nothing"
	msg "-h|--help : this help"
	msg "-v|--version : print plugin version"
	exit 1

}
###############################################################################

# test for arguments
while [[ $1 ]]
do
	case $1 in
	-n | --null )
		opt_null=y
		shift
	;;

	-h | --help )
		syntaxe
	;;

        -v | --version )
                msg "$0 version $version";
                exit 1;
        ;;

	*)
		msg "bad option : $1";
		syntaxe
	;;
	esac
done

# test the way to be called
case $LONG_OPTION in
	change-spec*)
		;;
	*)	msg "bad call : $LONG_OPTION (should be called from change-spec*)";
		syntaxe
	;;
esac

# modify spec file
while read line
do
	if [ -n "$opt_null" ]
	then
		# do nothing : just repeat
		echo "$line"
	else
		# add the plugin type on each spec line
		# it will not work any more, but let see which part is modified
		echo "$LONG_OPTION $line"
	fi
done 
