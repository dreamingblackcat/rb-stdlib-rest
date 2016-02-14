require 'webrick'
require 'pstore'
require 'json'

class DB

  attr_reader :table

  def initialize(table, path = 'db.pstore')
    @table = table
    @path  = path
    @store = PStore.new path
  end

  def all
    rows = []
    @store.transaction do
      rows = @store[table] 
    end
    p rows
    rows
  end

  def find(key, value)
    all.select do|row|
      row[key] == value
    end.first
  end

  def create row
    @store.transaction do
      @store[table] = @store[table].push row
    end
    row
  end

  def update(search_key, search_value, update_key, update_value)
    updated_row = nil
    @store.transaction do
      rows = @store[table]
      rows.map! do|row|
       if row[search_key] == search_value
         row[update_key] = update_value
         updated_row = row
       end
        row
      end
      @store[table] = rows
    end
    updated_row
  end

  def destroy(key, value)
    p key, value
    @store.transaction do
      rows = @store[table]
      before_count = rows.length
      rows.reject! do|row|
        row[key] ==  value 
      end
      if before_count == rows.length
        return false
      else
        @store[table] = rows
        return true
      end
    end
  end

  def flush
    @store.transaction do
      @store[table] = []
    end
  end
end

class BadRequestError < StandardError; end;

def parse_post_data body
  raise BadRequestError if body.nil?
  form_data = {}
  body.split('=').each_slice(2) do|key, val|
    form_data[key.to_sym] = val
  end
  form_data
end

book_db = DB.new 'books'

book_db.flush

["abc", "def"].each do|title|
  book_db.create({title: title})
end

server = WEBrick::HTTPServer.new Port: 4000

server.mount_proc '/books' do|req, res|
  res.content_type = 'application/json'
  case req.request_method
  when "GET"    
    p req.path, req.path_info, req.request_uri
    if req.path_info.empty? then
      res.status = 200
      res.body   = book_db.all.to_json
    else
      title = req.path_info.gsub('/', '')
      book  = book_db.find :title, title      
      if book.nil?
        res.status = 404
        res.body = {message: "No Such Book!"}.to_json
      else
        res.status = 200
        res.body = book.to_json
      end
    end
  when "POST"
    begin
      post_data = parse_post_data req.body      
    rescue BadRequestError => e
      res.status = 400
      res.body   = {message: "Please add correct url-encoded form data fields"}.to_json
    end
    if req.path_info.empty? then
      book = book_db.create post_data
      res.status = 200
      res.body   = book.to_json
    else
      if req.path_info.match /delete/
        title = req.path_info.gsub('/', '').gsub('delete', '')
        if book_db.destroy(:title, title)
          p "deleted!"
          res.status = 200
          res.body   = {message: "The book has been successfully deleted!"}.to_json
        else
          res.status = 404
          res.body   = {message: "There is no such book to delete"}
        end
      else
        title = req.path_info.gsub('/', '')
        updated_book = book_db.update :title, title, :title, post_data[:title]  
        res.status = 200
        res.body  = updated_book.to_json
      end
    end
  else
    res.status = 422
    res.body = "Unsupported HTTP Verb"
  end
end


trap("INT"){ server.shutdown }

server.start