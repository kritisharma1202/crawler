class ScrapedLink < ApplicationRecord
  validates :link, uniqueness: true
end
