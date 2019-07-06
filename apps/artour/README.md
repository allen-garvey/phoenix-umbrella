# Artour

A CMS and blog static site generator specifically designed for photography and artwork.

## Getting Started
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:3000`](http://localhost:3000) from your browser.

## Custom Mix Tasks
  * Render site to static HTML files `mix distill.html`
  * Copy static assets for static site `mix distill.static`
  * Convenience task to combine previous two tasks `mix distill.site`
  * Test image urls for 404s `mix distill.test.image_urls http://site_url.com/media/images/`
