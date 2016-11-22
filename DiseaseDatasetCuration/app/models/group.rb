class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  
  validates :name,  presence: true, length: { maximum: 50 }
  
  def get_users
  	groupusers=self.users
  	return groupusers
  end
  
  def get_admins
  	groupadmin=self.users.where(group_admin: true).pluck(:name)
  	#debugger
  	return groupadmin    #if groupadmin
  end
   
    
    
    
end
