#!/bin/bash

# --- Configuration ---
DEFAULT_MODEL="best_full_integer_quant_vela.tflite 0xB7B000 0x000000"
DEFAULT_FILE="we2_image_gen_local/output_case1_sec_wlcsp/output.img" # Default file path if needed elsewhere, but won't trigger flash
BAUDRATE=921600
PROTOCOL="xmodem"
PYTHON_SCRIPT="xmodem/xmodem_send.py" # Path to your python script

# --- Function to Detect Serial Port ---
detect_serial_port() {
  local port=""
  # Prioritize common USB-to-Serial adapters
  port=$(ls -1 /dev/cu.usb* 2>/dev/null | head -n 1)
  if [[ -n "$port" ]]; then
    echo "$port"
    return 0
  fi

  # Check for ACM devices (often used by microcontroller boards)
  port=$(ls -1 /dev/ttyACM* 2>/dev/null | head -n 1)
  if [[ -n "$port" ]]; then
    echo "$port"
    return 0
  fi

  # Check for AMA devices (common on Raspberry Pi GPIO)
  port=$(ls -1 /dev/ttyAMA* 2>/dev/null | head -n 1)
  if [[ -n "$port" ]]; then
    echo "$port"
    return 0
  fi

  # Add more checks if needed, e.g., /dev/ttyS* for built-in ports

  # If no port found, return empty
  echo ""
  return 1
}

# --- Argument Parsing ---
# Use provided model argument or default
MODEL_ARG="${1:-$DEFAULT_MODEL}" # $1 is the first argument (model), use default if empty

# --- Check if File Argument ($2) is provided ---
if [ -n "$2" ]; then
  # User provided the file path as the second argument, proceed with flashing
  USER_PROVIDED_FILE="$2"
  echo "User provided file path: '$USER_PROVIDED_FILE'. Proceeding with flash operation."

  # --- Serial Port Detection (only needed if flashing) ---
  DETECTED_PORT=$(detect_serial_port)

  if [[ -z "$DETECTED_PORT" ]]; then
    echo "Error: Could not automatically detect a serial port for flashing."
    echo "Checked for /dev/ttyUSB*, /dev/ttyACM*, /dev/ttyAMA*."
    echo "Please ensure your device is connected and you have permissions (e.g., member of 'dialout' group)."
    exit 1
  else
    echo "Detected Serial Port: $DETECTED_PORT"
  fi

  # --- Display Parameters for Flashing ---
  echo "Using Model:   '$MODEL_ARG'"
  echo "Using File:    '$USER_PROVIDED_FILE'" # Explicitly use the provided file
  echo "Baud Rate:     $BAUDRATE"
  echo "Protocol:      $PROTOCOL"
  echo "---"

  # --- Execute Flashing Command ---
  echo "Running Python script to flash..."
  python3 "$PYTHON_SCRIPT" \
    --port="$DETECTED_PORT" \
    --baudrate="$BAUDRATE" \
    --protocol="$PROTOCOL" \
    --file="$USER_PROVIDED_FILE" \
    --model="$MODEL_ARG"

  # Check the exit status of the python script
  EXIT_STATUS=$?
  if [ $EXIT_STATUS -ne 0 ]; then
    echo "Error: Python script (flash operation) exited with status $EXIT_STATUS."
    exit $EXIT_STATUS
  fi

  echo "Flash operation finished successfully."
  exit 0

else
  # User did NOT provide the file path as the second argument
  echo "File path argument (second argument) was not provided."
  echo "Skipping the flash operation."
  echo "Model argument resolved to: '$MODEL_ARG' (using provided or default)."
  # You could add other non-flashing actions here if needed
  exit 0
fi
