# Simple Text File Server and Client

This is a simple client and server for reading and writing text files, using secure TCP/IP connection with SSL.

## Getting Started

Clone this repository

```
$ git clone git@github.com:camyromao/text-file-server.git
```

Generate a self-signed certificate with OpenSSL

```
$ openssl req -x509 -newkey rsa:1024 -keyout key.pem -out certificate.pem -nodes -days 365 -subj 'CN=localhost'
```

Set port for server

```sh
# server.rb
...
Server.new(port)
```

## Running

Start server

```
$ ruby server.rb
```

Example (for server running on port 3000): 

- Open irb to use client

```
2.3.0 :001 > load 'client.rb'
2.3.0 :002 > client = Client.new("localhost", 3000)
2.3.0 :003 > client.send_request("read file", "example.txt")
 => {"response"=>["car", "house", "animal", "tv"]}
2.3.0 :004 >
```

## Built With

* Ruby 2.3.0

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Inspiration

* https://code.likeagirl.io/socket-programming-in-ruby-f714131336fd