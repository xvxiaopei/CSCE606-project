require 'rails_helper'

describe GroupsController do

    #Test user-control mechanism
    describe "take control of user's identity " do
        fixtures :users
        fixtures :groups
        before(:each) do
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(3).groups << Group.find_by_id(3)
        end
        
        it "has a 200 response status code if user is admin" do
            #Mock the verifing process
            allow_any_instance_of(GroupsHelper).to receive(:admins?).and_return(true)
            get :adduser, :id => 1
            expect(response.status).to eq(200)            
        end        
        it "rejects and redirect to the root page if user isn't admin" do
            get :adduser, :id => 1
            expect(response.status).to eq(302)              
            expect(response).to redirect_to(root_path)

        end
        it "responses to html format" do 
            #Mock the verifing process
            allow_any_instance_of(GroupsHelper).to receive(:admins?).and_return(true)
            get :adduser, :id => 1          
            expect(response.content_type).to eq "text/html"
        end
    end
    
    
    
    
    
end