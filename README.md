# Phoenix Umbrella

Elixir umbrella project containing several custom CMSs made with Elixir/Phoenix.

## Dependencies

* Elixir >= 1.12

* node >= 14

* npm

* PostgreSQL

## Getting Started

* Set environment variable `UMBRELLA_COOKIE_DOMAIN` for shared session cookie (e.g. `export UMBRELLA_COOKIE_DOMAIN=".umbrella.test"`)

* Set environment variable `UMBRELLA_SUPER_SEARCH_URL` for super search url (e.g. `export UMBRELLA_SUPER_SEARCH_URL="http://search.alaska.test"`)

* Clone or download this repo

* Run `mix deps.get`

* Run `npm install`

* Run `npm run deploy`

* Run `mix ecto.setup`

* Run `phxs`

## Individual App Documentation

Individual app documentation along with instructions for app specific mix tasks can be found in `README.md` files in the `./apps` directory

## License

Phoenix Umbrella is released under the MIT License. See license.txt for more details.