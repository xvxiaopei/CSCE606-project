require 'rails_helper'

describe Group do
    
    describe "finding users of the group" do 
        fixtures :users
        fixtures :groups
        before(:each) do
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(2).groups << Group.find_by_id(3)
        end
        #Test function .get_users
        #Happy Path
        it "returns the group users if there are users found." do
            @grp1=Group.find_by_id(1)
            @has_user = false
            @grp1.get_users.each do |user|
            #The class of user.groups is ActiveRecord::Associations::CollectionProxy
            #And it will never be nil if correct
                user.groups.to_a.each do |grp|
                    #Test if all the returned user's group name is "G1"
                    #which is desired.
                    if(grp.name == "G1")
                        @has_user = true
                    else
                        @has_user = false
                    end
                end
                expect(@has_user).to eq(true)
            end
        end
        #Sad Path
        it "returns empty collection set if no user in the group" do
            @grp4=Group.find_by_id(4) 
            @has_user = false    
            expect(@grp4.get_users.count).to eq(0)   
        end
    end
    
    describe "finding admins of the group" do
        fixtures :users
        fixtures :groups
        before(:each) do
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(2).groups << Group.find_by_id(3)
        end        
        

        
        
        
    end
    
    
    
    
    
    
    
    
    
end


    
    
    
    