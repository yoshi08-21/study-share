class Book < ApplicationRecord

belongs_to :user

validates :name,      presence: true, length: { maximum: 50 }, uniqueness: true
validates :author,    presence: true, length: { maximum: 25 }
validates :publisher, length: { maximum: 25 }
validates :subject,   presence: true


end

