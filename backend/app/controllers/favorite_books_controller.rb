class FavoriteBooksController < ApplicationController

  def create
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    book = Book.find_by(id: params[:book_id])
    return head :not_found unless book

    favorite_book = current_user.favorite_books.build(book_id: book.id)
    if favorite_book.save
      render json: favorite_book, status: 200
    else
      render json: { error: favorite_book.errors.full_messages }, status: 422
    end
  end

  def destroy
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    book = Book.find_by(id: params[:book_id])
    return head :not_found unless book

    favorite_book = current_user.favorite_books.find_by(book_id: book.id)
    return render json: { error: "お気に入りに登録されていません" }, status: 404 unless favorite_book

    if favorite_book.destroy
      head :no_content
    else
      render json: { error: favorite_book.errors.full_messages }, status: 422
    end
  end

  # favorite_book_idを持っていない一覧表示から呼び出すためのアクション
  def destroy_from_item_list
    current_user = User.find_by(id: params[:user_id])
    return head :not_found unless current_user

    book = Book.find_by(id: params[:book_id])
    return head :not_found unless book

    favorite_book = current_user.favorite_books.find_by(book_id: book.id)
    return render json: { error: "お気に入りに登録されていません" }, status: 404 unless favorite_book

    if favorite_book.destroy
      head :no_content
    else
      render json: { error: favorite_book.errors.full_messages }, status: 422
    end
  end



end
