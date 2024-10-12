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

* Make sure environment variables are set before compilation, as the values are set at compile time

* Clone or download this repo

* Run `mix deps.get`

* Run `npm install`

* Run `npm run deploy`

* In the Grenadier directory `cd apps/grenadier` run `mix ecto.setup`

* Still in the Grenadier directory, run the mix tasks to create a user (documented in `apps/grenadier/README.md`)

* In the project root directory run `mix phx.server`

## Individual App Documentation

Individual app documentation along with instructions for app specific mix tasks can be found in `README.md` files in the `./apps` directory

## Running in production

* Set environment variable `UMBRELLA_SECRET_KEY_BASE` using the result from `mix phx.gen.secret`

## Running npm tests

* Add `"type": "module"` to `package.json`
* Run `npm test`

## License

Phoenix Umbrella is released under the MIT License. See license.txt for more details.