#!/bin/sh -x
export ACME=${USERPROFILE}/Downloads/acme0.97win/acme
export VICE=${USERPROFILE}/Downloads/GTK3VICE-3.8-win64/bin
export PROG=strings
mkdir build 2>/dev/null
${ACME}/acme -f cbm -o build/${PROG}.prg -l build/${PROG}.lbl ${PROG}.asm \
&& ${VICE}/c1541 ${PROG}.d64 -attach ${PROG}.d64 8 -delete ${PROG} -write build/${PROG}.prg ${PROG}\
&& ${VICE}/x64sc -moncommands build/${PROG}.lbl -autostart ${PROG}.d64 >/dev/null 2>&1 &
