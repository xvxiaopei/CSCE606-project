class Fullquestion < ActiveRecord::Base
  require 'yaml'
  require 'csv'
  
  has_many :fullsubmissions
  has_many :users, :through => :fullsubmissions





  def Fullquestion.convert_ans(answer)
    
    ans = ['Yes','No','Not Given']
    
    ret = ans[answer.to_f-1]
    
    return ret

  end




end
