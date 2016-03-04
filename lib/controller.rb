require 'json'
require 'pstore'
require_relative './db'

class Controller
  Book = Struct.new(:title, :author, :id)
  BOOK_DB = DB.new 'books', PStore.new(File.dirname(__FILE__) + '/../db/production.store')

  def self.index
    [200, BOOK_DB.all.map(&:to_h).to_json]
  end

  def self.create params
    book = BOOK_DB<< Book.new(params[:title], params[:author])
    [201, book.to_h.to_json]
  end

  def self.show id
    book = BOOK_DB[id.to_s]
    if book
      [200, book.to_h.to_json]
    else
      [404, {message: "No Such Book!"}.to_json]
    end
  end

  def self.update id, params
    updated_book = BOOK_DB.update(id.to_s, {title: params[:title], author: params[:author]})
    unless updated_book.nil?
      [200, updated_book.to_h.to_json]
    else
      [404, {message: "No Such Book!"}.to_json]
    end      
  end
  
  def self.delete id
    BOOK_DB.delete id
    [200, {message: "The book has been deleted!"}.to_json]
  end
  
end