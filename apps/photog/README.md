# Photog Phoenix

Single page web app for your photo library. Originally designed to export Apple Photos library to a web app, but has diverged a bit now so may take some work. See [photog-phoenix project](https://github.com/allen-garvey/photog-phoenix) readme for more details if that interests you.

## Additional Dependencies for shutterbug mix task

* exiftool 
* ImageMagick

## Getting Started

* Create symbolic links for image directories by running:
* `ln -s <masters_directory> priv/static/media/images`
* `ln -s <thumbnails_directory> priv/static/media/thumbnails`

## Importing new images using the shutterbug mix task

JPEG, PNG, WebP and SVG image types are supported. This mix task both adds the images in a given source folder to the Photog database, and also generates thumbnail images and copies the original image source files to the your masters folder. Generated/copied files are placed inside folders based on the current date and time, using the same convention as Apple Photos.

* `mix shutterbug <source_folder>` takes the images in the source folder and copies the images and generated thumbnails to `./priv/static/media/images` and `./priv/static/media/thumbnails` respectively

* `mix shutterbug <source_folder> <destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `destination_folder/Masters` and `destination_folder/Thumnails` respectively

* `mix shutterbug <source_folder> <masters_destination_folder> <thumbnails_destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `masters_destination_folder` and `thumbnails_destination_folder` respectivly

## Adding Amazon Photos Ids to images

By adding Amazon Photos Ids to images, you can see an Amazon photos link on the image details page

* Sign in to Amazon cloud drive and view the contents of a folder with images in it. Save the AJAX response for `https://www.amazon.com/drive/v1/nodes?asset=ALL&tempLink=false` to a `.json` file

* Run `mix shutterbug.load_amazon_photos <json_file_path> <folder_name>` to load the Amazon Photo Ids for those images, where `folder_name` is the folder containing the images


## License

Photog Phoenix is released under the MIT License. See license.txt for more details.