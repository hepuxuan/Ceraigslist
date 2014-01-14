class EmailAlert < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_id, :price_min, :price_max, :search, :distance
  belongs_to :user
end
