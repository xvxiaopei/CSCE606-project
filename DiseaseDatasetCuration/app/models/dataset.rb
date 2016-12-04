class Dataset < ActiveRecord::Base
  serialize :Data_set, Array
  
  validates :name,  presence: true, length: { maximum: 50 }
  
end