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

  describe '#show' do
    it "shows a book with id" do
      Controller::BOOK_DB.stub :[], {title: 'my title', id: 1, author: 'jj'} do
        status, body = Controller.show(1)
        status.must_equal 200
        JSON.parse(body).must_equal({'title' => 'my title', 'id' => 1, 'author' => 'jj'})
      end
    end

    it "does not show a book with non-existent id" do
      Controller::BOOK_DB.stub :[], nil do
        status, body = Controller.show(1)
        status.must_equal 404
        JSON.parse(body).must_equal({"message" => "No Such Book!"})
      end
    end
  end

  describe '#update' do
    it "returns an updated book" do
      Controller::BOOK_DB.stub :update, {title: 'updated title', id: 1, author: 'jj'} do
        status, body = Controller.update(1, {title: 'updated title'})
        status.must_equal 200
        JSON.parse(body).must_equal({'title' => 'updated title', 'id' => 1, 'author' => 'jj'})
      end
    end 

    it "returns a not found message when the book to update is not found"  do
      Controller::BOOK_DB.stub :update, nil do
        status, body = Controller.update(1, {title: 'updated title'})
        status.must_equal 404
        JSON.parse(body).must_equal({'message' => 'No Such Book!'})
      end
    end
  end

  describe '#destroy' do
    it "deletes given book" do
      Controller::BOOK_DB.stub :delete, true do
        status, body = Controller.delete(1)
        status.must_equal 200
        JSON.parse(body).must_equal({"message"=>"The book has been deleted!"})
      end
    end
  end
end