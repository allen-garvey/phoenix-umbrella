# Photog Phoenix

Single page web app for your photo library. Originally designed to export Apple Photos library to a web app, but has diverged a bit now so may take some work. See [photog-phoenix project](https://github.com/allen-garvey/photog-phoenix) readme for more details if that interests you.

## Additional Dependencies for shutterbug mix task

* exiftool 
* ImageMagick

## Getting Started

* Create symbolic links for image directories by running:
* `mkdir -p priv/static/media`
* `ln -s <masters_directory> priv/static/media/images`
* `ln -s <thumbnails_directory> priv/static/media/thumbnails`

## Importing new images using the shutterbug mix task

JPEG, PNG, WebP and SVG image types are supported. This mix task both adds the images in a given source folder to the Photog database, and also generates thumbnail images and copies the original image source files to the your masters folder. Generated/copied files are placed inside folders based on the current date and time, using the same convention as Apple Photos.

* `mix shutterbug <source_folder>` takes the images in the source folder and copies the images and generated thumbnails to `./priv/static/media/images` and `./priv/static/media/thumbnails` respectively.

* To automatically convert jpg file masters to webp files on import to save space, use the `--webp` option after the source folder.

## Image url setup

* You can optionally set the environment variable `UMBRELLA_PHOTOG_IMAGE_URL_PREFIX` as a random string, which is used as a prefix for image urls
* If you do that, add aliases in your server configuration for image paths 

* You can also optionally set environment variable `UMBRELLA_PHOTOG_IMAGE_THUMBNAILS_ONLY`. Set it to `1` to only use thumbnail images in the Vue client, and not the master images

## Backblaze B2 Setup

* To enable Backblaze B2 downloads for image masters

* Set environment variable `UMBRELLA_PHOTOG_B2_APPLICATION_KEY` with a Backblaze B2 application key. The value should be base64 value of `keyId:applicationKey`

* Set environment variable `UMBRELLA_PHOTOG_B2_BUCKET_PREFIX` . The value should be the B2 bucket name and then the path to the masters directory (e.g. `bucket-name/path/to/masters-dir` note no forward slash at the end)


## License

Photog Phoenix is released under the MIT License. See license.txt for more details.