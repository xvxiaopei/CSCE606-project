require 'rails_helper'

describe GroupsController do
    #Views are stubbed in the controller spec by default
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
    
    
    #.adduser is hard to test because it's far too long
    #that it should be tested by feature specs
    
    #Test .index
    describe "show all the groups that an admin can manage" do
        fixtures :users
        fixtures :groups
        include SessionsHelper
        before(:each) do
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(3).groups << Group.find_by_id(3)
        end
        
        
        it "representing all groups if it's power admin" do
            log_in(User.find_by_id(4))
            get :index  
            #debugger
            expect(assigns(:all_groups).count).to eq(4)
            expect(response).to render_template(:index)            
            
        end
        it "only showing the groups that the group admin is in" do
            log_in(User.find_by_id(1))
            get :index  
            expect(assigns(:all_groups).count).to eq(1)
            expect(response).to render_template(:index)
        end
        
        
    end
    
    #.new/.create/.destroy/.edit/.update
    describe "Admins can create a new group" do
        fixtures :users
        fixtures :groups
        include SessionsHelper  
        before(:each) do
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(3).groups << Group.find_by_id(3)
        end
        it "should have a controller method and have 
           a instance variable to handle this request" do
            log_in(User.find_by_id(1))
            get :new  
            expect(assigns(:group).nil?).to be_falsy
            expect(assigns(:group)).to be_a_new(Group)
            expect(response).to render_template(:new)    
        end
        
        it "should create a new group with correct infos" do
            log_in(User.find_by_id(4))
            post :create, { :group => { :name => "New Group" } }
            expect(assigns(:group).save).to eq(true)   
            expect(response).to redirect_to(groups_path)
        end
        
        it "should reject creating if there's something wrong" do
            log_in(User.find_by_id(4))
            post :create, { :group => { :name => nil } }
            expect(assigns(:group).save).to eq(false)            
            expect(response).to render_template(:new)
        end
        
        it "should delete an exisiting group with confirmation" do
            log_in(User.find_by_id(4))
            delete :destroy, {:id => 1}
            expect(Group.count).to eq(3)
        end
        
        it "should be able to edit exisiting groups" do
            log_in(User.find_by_id(4))
            get  :edit,{:id => 1}
            expect(assigns(:group)).to eql(Group.find(1))
            expect(response).to render_template(:edit)
        end
        
        it "should be able to update with correct infos" do
            log_in(User.find_by_id(4))
            post :update, {:id => 1, :group => { :name => "New Group" }}
            expect(Group.find(1).name).to eql("New Group")
            expect(response).to redirect_to(groups_path)
        end
        it "should be redirected to editing page if there's something wrong." do
            log_in(User.find_by_id(4))
            post :update, {:id => 1, :group => { :name => nil }}
            expect(Group.find(1).name).to eql("G1")
            expect(response).to render_template(:edit)            
        end
    end
    
    
    
    #Test .quickadduser/.performadd
    
    
    
    
    
    
end