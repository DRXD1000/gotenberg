#!/bin/bash

# Drawio wrapper script to filter unwanted output messages
# Based on the approach used by the official drawio Docker image

set -e

# Set default paths if not provided
DRAWIO_DESKTOP_SOURCE_FOLDER="${DRAWIO_DESKTOP_SOURCE_FOLDER:-/opt/drawio-desktop}"
DRAWIO_BIN_PATH="${DRAWIO_BIN_PATH:-/usr/bin/drawio}"

# Create combined filter file
cat "${DRAWIO_DESKTOP_SOURCE_FOLDER}/unwanted-security-warnings.txt" > "${DRAWIO_DESKTOP_SOURCE_FOLDER}/unwanted-lines.txt"
cat "${DRAWIO_DESKTOP_SOURCE_FOLDER}/unwanted-update-logs.txt" >> "${DRAWIO_DESKTOP_SOURCE_FOLDER}/unwanted-lines.txt"

# Run drawio with xvfb-run for proper X11 context and filter output
# We need to preserve the exit code of the drawio command
set +e
output=$(xvfb-run "${DRAWIO_BIN_PATH}" --no-sandbox --disable-gpu "$@" 2>&1)
exit_code=$?
set -e

# Filter the output and display it
echo "$output" | grep -Fvf "${DRAWIO_DESKTOP_SOURCE_FOLDER}/unwanted-lines.txt" || true

# Exit with the same code as drawio
exit $exit_code
