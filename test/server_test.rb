# require 'minitest/autorun'
# require_relative '../lib/server'
##TODO - figure out how to isolate server code from webbrick
# describe BookServer do
#   FakeRequest = Struct.new(:request_method, :path_info)
#   @server     = BookServer.new
#   it "serves collection requests" do
#     request = FakeRequest.new("GET", "/books")
#     WEBrick::HTTPRequest.stub :new, request do
#       @server.do_GET()
#     end
#   end
# end