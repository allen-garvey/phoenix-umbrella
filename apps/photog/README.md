# Photog Phoenix

Single page web app for your photo library. Originally designed to export Apple Photos library to a web app, but has diverged a bit now so may take some work. See [photog-phoenix project](https://github.com/allen-garvey/photog-phoenix) readme for more details if that interests you.

## Additional Dependencies

* exiftool
* ImageMagick (optional, required for shutterbug mix task)

## Getting Started

* Run the command `mkdir -p priv/static/media/images && mkdir -p priv/static/media/thumbnails` to create the folders for images
* Create a system link from your Apple Photos library `Masters` folder to the `images` folder you just created, and a system link from your Apple Photos library `Thumbnails` folder to the `thumbnails` folder you just created 

## Importing new images using the shutterbug mix task

For now, this only works on `.jpg` and `.png` image types. This mix task both adds the images in a given source folder to the Photog database, but also generates thumbnail images and copies the original image source files to the your masters folder. Generated/copied files are placed inside folders based on the current date and time, using the same convention as Apple Photos.

* `mix shutterbug <source_folder>` takes the images in the source folder and copies the images and generated thumbnails to `./priv/static/media/images` and `./priv/static/media/thumbnails` respectively

* `mix shutterbug <source_folder> <destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `destination_folder/Masters` and `destination_folder/Thumnails` respectively

* `mix shutterbug <source_folder> <masters_destination_folder> <thumbnails_destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `masters_destination_folder` and `thumbnails_destination_folder` respectivly


## License

Photog Phoenix is released under the MIT License. See license.txt for more details.