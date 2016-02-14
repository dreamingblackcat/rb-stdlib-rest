require 'minitest/autorun'
require_relative '../lib/controller'

describe Controller do
  
  describe '#index' do
    
    it "succesfully get all books" do
      Controller::BOOK_DB.stub :all, [{title: 'my title', id: 1, author: 'jj'}] do
        status, body = Controller.index
        status.must_equal 200
        JSON.parse(body).must_be_kind_of Array
      end
    end
  end

  describe '#create' do
    
    it "creates a book with correct input" do
      Controller::BOOK_DB.stub :<<, {title: 'my title', id: 1, author: 'jj'} do
        status, body = Controller.create({title: 'my title', author: 'jj'})
        status.must_equal 201
        JSON.parse(body).must_equal({'title' => 'my title', 'id' => 1, 'author' => 'jj'})
      end
    end
  end
end