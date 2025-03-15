# Bash Script to Tar Files with Validation

Get the list of docker images from a json file. The json file is like:

images:[
{
  name: <image_name>
  version:<image version>
}, 
{
  name: <image_name>
  version:<image version>
},
{
  name: <image_name>
  version:<image version>
} 
]

The bash script will create a folder named imagesDpl where all the images must be stored for later use.

Then, when all the images are donwloaded, we need to get the SHA-256 for every image file.
Store the SHA-256 results in another json file like with its file name and SHA.

After that, we need to create a TAR file of that folder. It means that all the images will be in a TAR file.

After all the operation, then we need to printout the json file using jq, so the user can copy the file name with version of the image and its respective SHA so it can verified later.
