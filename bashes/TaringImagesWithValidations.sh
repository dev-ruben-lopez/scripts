#!/bin/bash

# Input JSON file containing the list of images
INPUT_JSON="images.json"
OUTPUT_DIR="imagesDpl"
HASH_FILE="image_hashes.txt"
TAR_FILE="imagesDpl.tar"

# Ensure jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Create the output directory
mkdir -p "$OUTPUT_DIR"

# Clear the previous hash file
echo "Filename | SHA-256 Hash" > "$HASH_FILE"
echo "------------------------" >> "$HASH_FILE"

# Read images from JSON file
IMAGES=$(jq -c '.images[]' "$INPUT_JSON")

# Loop through images
echo "Pulling and saving Docker images..."
for IMAGE in $IMAGES; do
    NAME=$(echo "$IMAGE" | jq -r '.name')
    VERSION=$(echo "$IMAGE" | jq -r '.version')
    IMAGE_TAG="${NAME}:${VERSION}"
    FILE_NAME="${NAME//\//_}_${VERSION}.tar"

    echo "Processing: $IMAGE_TAG"

    # Pull Docker image
    docker pull "$IMAGE_TAG"
    if [ $? -ne 0 ]; then
        echo "Failed to pull image: $IMAGE_TAG"
        continue
    fi

    # Save Docker image to file
    docker save -o "$OUTPUT_DIR/$FILE_NAME" "$IMAGE_TAG"

    # Compute SHA-256 hash
    SHA256=$(sha256sum "$OUTPUT_DIR/$FILE_NAME" | awk '{print $1}')

    # Append filename and hash to the text file
    echo "$FILE_NAME | $SHA256" >> "$HASH_FILE"
done

# Create a TAR file of the directory
tar -cvf "$TAR_FILE" "$OUTPUT_DIR"

# Print the hash file content at the end
echo -e "\nSHA-256 Hashes of Saved Images:"
cat "$HASH_FILE"
