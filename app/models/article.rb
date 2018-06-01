class Article < ApplicationRecord
  validates :headline, presence: true
  validates :content, presence: true
  belongs_to :category
  has_many :comments

  update_index('article') { self }
end
