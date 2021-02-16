#!/bin/bash

set -o nounset
set -o errexit

# Configures Emacs for building native comp support
# http://akrl.sdf.org/gccemacs.html

# Installing under homebrew's opt, but could be anywhere.
#readonly GCCEMACS_PREFIX="$(realpath $(brew --prefix)/opt/gccemacs)"
#readonly GCCEMACS_PREFIX="$SANDBOX/gccemacs"
readonly GCCEMACS_PREFIX="$PWD/nextstep/Emacs.app/Contents/MacOS"

readonly GCC_DIR="$(realpath $(brew --prefix)/opt/gcc)"
[[ -d $GCC_DIR ]] ||  { echo "${GCC_DIR} not found"; exit 1; }

readonly SED_DIR="$(realpath $(brew --prefix)/opt/gnu-sed)"
[[ -d $SED_DIR ]] ||  { echo "${SED_DIR} not found"; exit 1; }

readonly GCC_INCLUDE_DIR=${GCC_DIR}/include
[[ -d $GCC_INCLUDE_DIR ]] ||  { echo "${GCC_INCLUDE_DIR} not found"; exit 1; }

#readonly GCC_LIB_DIR=${GCC_DIR}/lib/gcc/10
readonly GCC_LIB_DIR=$(realpath $(brew --prefix)/lib/gcc/10)
[[ -d $GCC_LIB_DIR ]] ||  { echo "${GCC_LIB_DIR} not found"; exit 1; }

export PATH="${SED_DIR}/libexec/gnubin:${PATH}"
export CFLAGS="-I/usr/local/include -I${GCC_INCLUDE_DIR}"
export LDFLAGS="-L${GCC_LIB_DIR} -I${GCC_INCLUDE_DIR}"
export DYLD_FALLBACK_LIBRARY_PATH="${GCC_LIB_DIR}"

echo "Environment"
echo "-----------"
echo PATH: $PATH
echo CFLAGS: $CFLAGS
echo LDFLAGS: $LDFLAGS
echo DYLD_FALLBACK_LIBRARY_PATH: $DYLD_FALLBACK_LIBRARY_PATH
echo "-----------"

./autogen.sh

./configure \
     --prefix="${GCCEMACS_PREFIX}" \
     --enable-locallisppath="${GCCEMACS_PREFIX}/opt/gccemacs/site-lisp" \
     --with-ns \
     --with-mailutils \
     --with-cairo \
     --with-modules \
     --with-xml2 \
     --with-gnutls \
     --with-json \
     --with-rsvg \
     --with-nativecomp \
     --with-xwidgets \
     --with-harfbuzz \
     --disable-silent-rules \
     --disable-ns-self-contained
     #--without-dbus
     #--with-imagemagick
