#!/usr/bin/env bash

usage() {
    echo "Usage: $0 <qml-file>"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

QML_FILE="$1"

if [ ! -f "$QML_FILE" ]; then
    echo "Error: File '$QML_FILE' not found"
    exit 1
fi

NEW_COLORS=$(matugen image "$(qs -c lock ipc call img get)" -t scheme-tonal-spot -j hex | jq '.colors.dark')

# Check if color generation was successful
if [ -z "$NEW_COLORS" ] || [ "$NEW_COLORS" = "null" ]; then
    echo "Error: Failed to get colors from matugen"
    exit 1
fi

# Create backup of original file
BACKUP_FILE="${QML_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$QML_FILE" "$BACKUP_FILE"
echo "Created backup: $BACKUP_FILE"

# Create temporary sed script file
TEMP_SED_SCRIPT=$(mktemp)

# Generate sed commands for color replacement within ColorsComponent
echo "$NEW_COLORS" | jq -r '
to_entries[] | 
"s/\\(component ColorsComponent:.*\\n\\([[:space:]]*readonly property color " + .key + ":[[:space:]]*\\)\\)\"[^\"]*\"/\\1\"" + .value + "\"/g"
' > "$TEMP_SED_SCRIPT"

# Alternative approach: Generate sed commands that work within the ColorsComponent block
echo "$NEW_COLORS" | jq -r '
to_entries[] | 
"/component ColorsComponent:/,/^[[:space:]]*}[[:space:]]*$/ s/\\(readonly property color " + .key + ":[[:space:]]*\\)\"[^\"]*\"/\\1\"" + .value + "\"/g"
' > "$TEMP_SED_SCRIPT"

# Apply the color changes using sed
if sed -f "$TEMP_SED_SCRIPT" -i "$QML_FILE"; then
    echo "0"
    
    
    echo -e "\nVerifying changes in ColorsComponent..."
    if grep -A 100 "component ColorsComponent:" "$QML_FILE" | grep -B 100 "^[[:space:]]*}[[:space:]]*$" | head -n -1 | grep "readonly property color" | head -5; then
        echo "✓ Colors successfully updated in ColorsComponent"
    else
        echo "⚠ Warning: Could not verify color updates"
    fi
    
else
    echo "Error: Failed to update colors, backup"
    # Restore backup on failure
    mv "$BACKUP_FILE" "$QML_FILE"
    exit 1
fi

# Clean up temporary files
rm -f "$TEMP_SED_SCRIPT"

echo -e "\n0"
