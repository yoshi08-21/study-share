class ApplicationController < ActionController::API

  def validate_authorship(current_user, author)
    current_user == author
  end


end
