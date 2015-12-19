class Album < ActiveRecord::Base
  has_many :photos
  belongs_to :user
  self.per_page = 6 
end
