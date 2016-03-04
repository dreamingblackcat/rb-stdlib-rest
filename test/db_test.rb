require 'minitest/autorun'
require 'pstore'
require_relative '../lib/db'

describe DB do
  PSTORE = PStore.new File.dirname(__FILE__) + "/../db/test_db.pstore"
  Book    = Struct.new(:title, :author, :id)
  before do
    @db     = DB.new 'books', PSTORE
  end

  it 'allows to add a new book' do
    book = Book.new("my title", "my author")
    @db<< book
    book.id = 1
    PSTORE.transaction(true) { PSTORE['books']["1"].must_equal book }
  end
  it 'allows to get all books' do
    book = Book.new("my title", "my author", 1)
    PSTORE.transaction { PSTORE['books'] = {"1" => book} }
    @db.all.must_equal [book]
  end
  it 'allows to get a book by id' do
    book = Book.new("my title", "my author", 1)
    PSTORE.transaction { PSTORE['books'] = {"1" => book} }
    @db["1"].must_equal book
  end
  it 'allows to update a book by id' do
    book = Book.new("my title", "my author", 1)
    PSTORE.transaction { PSTORE['books'] = {"1" => book} }
    @db.update "1", {title: "updated title"}
    PSTORE.transaction { PSTORE['books']["1"].title.must_equal "updated title"}
  end
  it 'allows to delete a book by id' do
    book = Book.new("my title", "my author", 1)
    PSTORE.transaction { PSTORE['books'] = {"1" => book} }
    @db.delete "1"
    PSTORE.transaction { PSTORE['books']["1"].must_be_nil }
  end
end

