# Photog Phoenix

Turn your Apple Photos library into a web application

## Dependencies

* node >= 8
* npm
* elixir >= 1.5
* exiftool
* ImageMagick (optional, required for shutterbug mix task)

## Getting Started

* Install dependencies with `mix deps.get && npm install`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Compile JavaScript and Sass files with `npm run webpack:dev`
* Run the command `mkdir -p priv/static/media/images && mkdir -p priv/static/media/thumbnails` to create the folders for images
* Create a system link from your Apple Photos library `Masters` folder to the `images` folder you just created, and a system link from your Apple Photos library `Thumbnails` folder to the `thumbnails` folder you just created 
* Start Phoenix endpoint with `mix phx.server`
* Now you can visit [`localhost:3000`](http://localhost:3000) from your browser

## Importing Apple Photos Library Database

* Setup the project by following the getting started guide
* Run the export script in the [Photog-spark project](https://github.com/allen-garvey/photog-spark) to export your Photos Library as a SQL file
* Import the file by running `psql photog_dev < your-export-file.sql`

## Importing new images using the shutterbug mix task

Note that this bypasses your Apple Photos database, so only do this if you are ready to migrate away from Apple Photos. For now, this only works on .jpg and .png image types. This mix task both adds the images in a given source folder to the Photog database, but also generates thumbnail images and copies the original image source files to the your masters folder. Generated/copied files are placed inside folders based on the current date and time, using the same convention as Apple Photos.

* `mix shutterbug <source_folder>` takes the images in the source folder and copies the images and generated thumbnails to `./priv/static/media/images` and `./priv/static/media/thumbnails` respectively

* `mix shutterbug <source_folder> <destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `destination_folder/Masters` and `destination_folder/Thumnails` respectively

* `mix shutterbug <source_folder> <masters_destination_folder> <thumbnails_destination_folder>` takes the images in the source folder and copies the images and generated thumbnails to `masters_destination_folder` and `thumbnails_destination_folder` respectivly


## License

Photog Phoenix is released under the MIT License. See license.txt for more details.