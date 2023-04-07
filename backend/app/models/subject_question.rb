class SubjectQuestion < ApplicationRecord

  belongs_to :user


  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true


end
