module RecordChecker

  def exist_favorite_book?(current_user, book)
    current_user.fav_books.include?(book)
  end

end
