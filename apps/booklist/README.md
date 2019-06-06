# Booklist-phoenix

A CMS to keep track of the books you want to read, and their library availability to better coordinate your library visits.

## Dependencies

* Elixir >= 1.5
* node >= 8.0

## Getting Started

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create -r Booklist.Repo && mix ecto.migrate -r Booklist.Repo`
* Install Node.js dependencies with `cd assets && npm install && cd ../`
* Start Phoenix endpoint with `mix phx.server`
* Now you can visit [`localhost:5050`](http://localhost:5050) from your browser.

## Custom mix tasks

* There is a custom mix task `mix teamster` to migrate the database from [booklist-rails](https://github.com/allen-garvey/booklist-rails)
* To run this task, first configure the legacy database location in `config/dev.exs`
* Then enable the legacy repo on application start by uncommenting the line in `lib/booklist/application.ex`
* Then run `mix teamster`

## License

Booklist-phoenix is released under the MIT License. See license.txt for more details.