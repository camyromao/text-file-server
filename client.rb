require 'socket'
require 'openssl'
require 'json'

class Client
    def initialize(host, port)
      socket = TCPSocket.open(host, port)
      @ssl_client = OpenSSL::SSL::SSLSocket.new(socket)
      @ssl_client.sync_close = true
      @ssl_client.connect
    end

    def send_request(action, arg1="", arg2="")
      request = {:action => "#{action}", :arg1 => "#{arg1}", :arg2 => "#{arg2}"}

      Thread.fork {
        @ssl_client.puts request.to_json
      }.join

      res = listen_response
    end

    private
    def listen_response
      response = ""
      Thread.fork {
        response = @ssl_client.gets.chomp
      }.join
      JSON.parse(response)
    end

end