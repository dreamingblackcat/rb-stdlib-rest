# rb-stdlib-rest

This is a fun exercise of building a simple rest api web server using only ruby stdlib.

Note:**It was created using ruby-2.1.5 . Later versions of ruby has remove minitest from stdlib.**

The stdlib libraries used are

- __minitest__
- __json__
- __webrick__
- __minitest__

## Running the server

- Clone the repo
- `cd` into the repo
- run `ruby lib/server.rb`

Now the server will be up on `localhost:4000`.

- CREATE            => POST /books        (body fields => title, author <currently only support x-www-form-urlencoded>)
- UPDATE            => POST /books/:id    (body fields => title, author <currently only support x-www-form-urlencoded>)
- READ COLLECTION   => GET  /books
- READ SINGULAR     => GET  /books/:id
- DELETE            => POST /books/:id/delete

## Running the tests

- Run `rake` command

#TODO

- Add tests for the server code itself
- Add a rake test for running server??
- Add commandline options for specifying port
- Support correct HTTP VERBS (DELETE and PATCH)
- Support form-data, json payload for CREATE and UPDATE 
