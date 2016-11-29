class Dataset < ActiveRecord::Base
  serialize :Data_set, Hash
  
  validates :name,  presence: true, length: { maximum: 50 }
  
  
  def data_in(key,value)
      if !self.Data_set.has_key?(key)
          self.Data_set[key]=value
      else
          self.Data_set[key]=self.Data_set[key].concat(value)
      end
  end
  
  def data_out(key)
     return self.Data_set[key] 
  end
  
  def data_has_key(key)
     if self.Data_set.has_key?(key)
       return true
     else
       return false
     end
  end
  
  
end