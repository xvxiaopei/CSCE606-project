class Dataset < ActiveRecord::Base
  serialize :Dataset, Hash
  
  def data_in(key,value)
      if self.Dataset[key]==nil
          self.Dataset[key]=value
      else
          self.Dataset[key]=self.Dataset[key].concat(value)
      end
  end
  
  def data_out(key)
     return self.Dataset[key] 
  end
end