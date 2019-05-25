require 'socket'
require 'openssl'
require 'json'

class Server

  def initialize(port)
    socket = TCPServer.open(port)
    ssl_context = OpenSSL::SSL::SSLContext.new
    ssl_context.cert = OpenSSL::X509::Certificate.new(File.open('certificate.pem'))
    ssl_context.key = OpenSSL::PKey::RSA.new(File.open('key.pem'))
    @ssl_server = OpenSSL::SSL::SSLServer.new(socket, ssl_context)
    @close = false

    puts 'Started server.........'

    run
  end

  def run
    loop do
        Thread.fork(@ssl_server.accept) do |conn|
            begin
              while (lineIn = conn.gets)
                lineIn = lineIn.chomp
                $stdout.puts "Client message: #{lineIn}."
                res = check_command(lineIn)
                conn.puts "#{res}"
                conn.close if @close
              end
            rescue
              $stderr.puts $!
            end
        end
    end
  end

  def check_command(command)
    cmd = JSON.parse(command)
    case cmd["action"]
    when "read file"
        read_file(cmd["arg1"])
    when "write file"
        write_file(cmd["arg1"], cmd["arg2"])
    when "close connection"
        @close = true
        {response: "Connection closed."}.to_json
    else
        return "Invalid command."
    end
  end

  def read_file(filename)
    return_value = `cat #{filename}`
    elements = return_value.split("\n")
    response = {response: elements}
    response.to_json
  end

  def write_file(filename, text)
    # Check if file already exists
    file = `ls | grep #{filename}`
    if file.empty?
        `echo #{text} > #{filename}`
        msg = "File written!"
    else
        msg = "File already exists."
    end
    response = {response: msg}
    response.to_json
  end

end

# Set port
Server.new(port)
