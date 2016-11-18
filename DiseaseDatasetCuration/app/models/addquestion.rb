class Addquestion < ActiveRecord::Base
    
  has_and_belongs_to_many :users
  
  def get_users
  	addquestionusers=self.users
  	return addquestionusers
  end
  
  def get_admins
  	addquestionadmin=self.users.where(addquestion_admin: true).pluck(:name)
  	#debugger
  	return addquestionadmin    if addquestionadmin
  end
    
end
