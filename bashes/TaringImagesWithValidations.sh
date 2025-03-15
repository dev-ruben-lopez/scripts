#!/bin/bash

# Input JSON file containing image list
INPUT_JSON="images.json"
OUTPUT_DIR="imagesDpl"
HASH_FILE="image_hashes.json"
TAR_FILE="imagesDpl.tar"

# Ensure jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Create the output directory
mkdir -p "$OUTPUT_DIR"

# Read images from JSON file
IMAGES=$(jq -c '.images[]' "$INPUT_JSON")

# Clear previous hash file
echo "[]" > "$HASH_FILE"

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

    # Store hash in JSON file
    jq --arg file "$FILE_NAME" --arg sha "$SHA256" '. += [{"file": $file, "sha256": $sha}]' "$HASH_FILE" > tmp.json && mv tmp.json "$HASH_FILE"
done

# Create a TAR file of the directory
tar -cvf "$TAR_FILE" "$OUTPUT_DIR"

# Print the JSON hash file in a readable format
echo "SHA-256 hashes for saved images:"
jq . "$HASH_FILE"
