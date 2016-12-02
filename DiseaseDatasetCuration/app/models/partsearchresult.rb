class Partsearchresult < ActiveRecord::Base
    serialize :Data_set_results, Hash
    
  def data_in(key,value)
#      if !self.Data_set.has_key?(key)
          self.Data_set_results[key]=value
#      else
#          self.Data_set[key]=self.Data_set[key].concat(value)
#      end
  end
  
  def data_out(key)
     return self.Data_set_results[key] 
  end
  
  def data_has_key(key)
     if self.Data_set_results.has_key?(key)
       return true
     else
       return false
     end
  end
  
  def data_delete(key)
    self.Data_set_results.delete(key)
  end    
    
    
    
    
end
