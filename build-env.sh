#!/bin/sh
# Sets up the environment for building github.com/omegahd/qml against Qt 6.
#
# The dynamic meta object support depends on Qt private headers whose include
# paths embed the exact Qt version, so CGO_CPPFLAGS must be derived from the
# installation. Source this script (do not execute it) before building:
#
#     . ./build-env.sh            # auto-detect Qt via qtpaths6/qmake6
#     . ./build-env.sh /opt/Qt/6.11.1/gcc_64
#     . ./build-env.sh C:/Qt6/6.11.1/mingw_64   # Windows (Git Bash)
#
# On Debian/Ubuntu the required packages are:
#     qt6-base-dev qt6-base-private-dev qt6-declarative-dev pkg-config
# and for the webengine subpackage additionally:
#     qt6-webengine-dev

qt_prefix="$1"

if [ -n "$qt_prefix" ]; then
	QT_HEADERS="$qt_prefix/include"
	QT_LIBS="$qt_prefix/lib"
	QT_BINS="$qt_prefix/bin"
	QT_VERSION=`sed -n 's/^Version: *//p' "$QT_LIBS/pkgconfig/Qt6Core.pc" 2>/dev/null`
else
	for tool in qtpaths6 qtpaths qmake6 qmake; do
		if command -v $tool >/dev/null 2>&1; then
			case $tool in
			qmake*)
				QT_HEADERS=`$tool -query QT_INSTALL_HEADERS`
				QT_LIBS=`$tool -query QT_INSTALL_LIBS`
				QT_BINS=`$tool -query QT_INSTALL_BINS`
				QT_VERSION=`$tool -query QT_VERSION`
				;;
			*)
				QT_HEADERS=`$tool --query QT_INSTALL_HEADERS`
				QT_LIBS=`$tool --query QT_INSTALL_LIBS`
				QT_BINS=`$tool --query QT_INSTALL_BINS`
				QT_VERSION=`$tool --query QT_VERSION`
				;;
			esac
			break
		fi
	done
fi

if [ -z "$QT_VERSION" ]; then
	echo "build-env.sh: cannot find Qt 6 (install qtpaths6/qmake6 or pass the Qt prefix as an argument)" >&2
elif [ "${QT_VERSION%%.*}" != 6 ]; then
	echo "build-env.sh: found Qt $QT_VERSION, but Qt 6 is required" >&2
else
	QT_PKGCONFIG="$QT_LIBS/pkgconfig"

	# Under Git Bash / MSYS, entries in colon-separated path lists must be
	# POSIX style (/c/...), or pkg-config misparses the drive-letter colon.
	case `uname -s 2>/dev/null` in
	MINGW*|MSYS*)
		if command -v cygpath >/dev/null 2>&1; then
			QT_PKGCONFIG=`cygpath -u "$QT_PKGCONFIG"`
			QT_BINS=`cygpath -u "$QT_BINS"`
		fi
		;;
	esac

	# Private headers of the modules used by the qml package and its tools.
	CGO_CPPFLAGS="-I$QT_HEADERS/QtCore/$QT_VERSION -I$QT_HEADERS/QtCore/$QT_VERSION/QtCore $CGO_CPPFLAGS"
	export CGO_CPPFLAGS

	PKG_CONFIG_PATH="$QT_PKGCONFIG${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH

	PATH="$QT_BINS:$PATH"
	export PATH

	echo "Using Qt $QT_VERSION"
	echo "  headers:         $QT_HEADERS"
	echo "  pkg-config path: $QT_PKGCONFIG"
	echo "  CGO_CPPFLAGS:    $CGO_CPPFLAGS"
fi
