class FavoriteReply < ApplicationRecord

  belongs_to :user
  belongs_to :reply

  validates_uniqueness_of :reply_id, scope: :user_id


end
