require 'webrick'
require_relative './controller'

class BadRequestError < StandardError; end;

class BookServer < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response
    status, body = nil, nil
    if request.path_info.empty? then
     status, body = Controller.index
    else
      id = request.path_info.gsub('/', '')
      status, body = Controller.show id
    end
    response.status = status
    response['Content-Type'] = "application/json"
    response.body = body
  end

  def do_POST request, response
    begin
      post_data = parse_post_data request.body  
      status, body = nil, nil
      if request.path_info.empty? then
        status, body = Controller.create post_data
      else
        id = request.path_info.gsub('/', '').gsub('delete', '')
        if request.path_info.match /delete/
          status, body = Controller.delete id
        else
          status, body = Controller.update id, post_data  
        end
      end
      response.status = status
      response['Content-Type'] = "application/json"
      response.body = body    
    rescue BadRequestError => e
      response.status = 400
      response.body   = {message: "Please add correct url-encoded form data fields"}.to_json
    end
  end

  private

    def parse_post_data request_body
      raise BadRequestError if request_body.nil?
      form_data = {}
      request_body.split('&').each do|pair_str|
        key, val = pair_str.split('=')
        form_data[key.to_sym] = val
      end
      form_data
    end
end

server = WEBrick::HTTPServer.new Port: 4000

server.mount '/books', BookServer

trap("INT"){ server.shutdown }

server.start