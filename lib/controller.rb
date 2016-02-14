require 'json'
require 'pstore'
require_relative './db'

class Controller
  BOOK_DB = DB.new 'books', PStore.new('../db/production.store')
  Book = Struct.new(:title, :author, :id)

  def self.index
    [200, BOOK_DB.all.to_json]
  end

  def self.create params
    book = BOOK_DB<< Book.new(params[:title], params[:author])
    [201, book.to_json]
  end
  
  
end