# Artour

A CMS and blog static site generator specifically designed for photography and artwork.

## Getting Started
  * Create symbolic links for image directories by running:
  * `ln -s <images_of_artwork_directory> priv/static/media/images`
  * If the directory changes, run `ln -sfn <new_artwork_directory> priv/static/media/images`

## Custom Mix Tasks
  * Render site to static HTML files `mix distill.html`
  * Copy static assets for static site `mix distill.static`
  * Convenience task to combine previous two tasks `mix distill.site`
  * Test image urls for 404s `mix distill.test.image_urls https://site_url.com/media/images/`

### Guggenheim
  * Create image sizes and import images to database `mix guggenheim <folder_path>`
  * If there is a four digit year in the folder name, separated from other words by spaces, underscores or hypens it will be used as the year for the imported images
  * Optionally you can pass a second argument that will be used as the description for all imported images
  * 2 thumbnails will be generated, one that crops to the center, and another that uses a conserve energy algorithm to warp to a square image
