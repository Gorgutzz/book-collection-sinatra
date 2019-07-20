class BookController < ApplicationController

    get '/books' do
      if Helpers.is_logged_in?(session)
        @books = Book.all
        erb :'/books/books'
      else
        flash[:error] = "Must be logged in."
        redirect to '/users/login'
      end
    end

    get '/books/new' do
        user = Helpers.current_user(session)
        if user.nil?
          flash[:error] = "Must be logged in to add books."
          redirect to '/login'
        else
          erb :'books/new'
        end
      end

      post '/book' do
        user = Helpers.current_user(session)
      if user.nil?
        redirect to '/login'
      elsif (params[:book][:book_title].empty? || params[:book][:author_name].empty?)
        flash[:error] = "Book title and author fields must be filled."
        redirect to '/books/new'
      else
        @book = Book.create(params['book'])
        @book[:user_id] = user.id
        @book.save
      end

      redirect to "/books/#{@book.id}"
    end

    get '/books/:id' do
      if  Helpers.is_logged_in?(session)
        @book = Book.find(params[:id])
        @users = User.all
        erb :'/books/show'
      else
        redirect to '/login'
      end
    end

    get '/books/:id/edit' do
      if Helpers.is_logged_in?(session)
        @book = Book.find(params[:id])
        erb :'/books/edit'
        else
          flash[:error] = "Must be logged in to edit books."
          redirect to '/login'
        end
    end

    patch '/books/:id' do
      @book = Book.find(params[:id])
      if params[:book][:book_title].empty?
        redirect to "/books/#{@book.id}/edit"
      end
      @book.update(params[:book])
      @book.save
      redirect to "/books/#{@book.id}"
    end

    delete '/books/:id/delete' do
      if !Helpers.is_logged_in?(session)
        flash[:error] = "Must be logged in as user which posted the book to delete it."
        redirect to '/login'
      elsif @book = Book.find(params[:id])
        if @book.user == Helpers.current_user(session)
          @book.delete
        end
        redirect to '/menu'
      end
    end


    get '/view_all' do
      if Helpers.is_logged_in?(session)
        @books = Book.all
        erb :'books/book_index'
      else
        flash[:error] = "Must be logged in to view all books."
        redirect to '/login'
      end
    end

end
