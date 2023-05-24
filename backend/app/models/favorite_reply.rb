class FavoriteReply < ApplicationRecord

  belongs_to :user
  belongs_to :reply

  validates :user_id, presence: true
  validates :reply_id, presence: true

end
