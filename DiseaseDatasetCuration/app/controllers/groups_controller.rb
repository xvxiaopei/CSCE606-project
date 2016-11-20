class GroupsController < ApplicationController
    include GroupsHelper
    include AdminsHelper
    before_action :admins?
    
    def new
        @group=Group.new
    end
    
    def create
        @group=Group.new(group_params)
        if @group.save
            flash[:success] = "#{@group.name} was successfully created."
            redirect_to groups_path
        else
            render 'new'
        end
    end
    
    
    
    def index
        if current_user.admin? 
                
            if !current_user.group_admin?      #main admin
                @all_groups = Group.all
            else 
                @all_groups = Group.where("admin_uid = ?", current_user.id)
            end
        end
        #debugger
    end
    
    def edit
        @group=Group.find(params[:id])
    end
    
    def update
        
        @group=Group.find params[:id]
        @group.update_attributes!(group_params)
        flash[:success]="#{@group.name} was successfully updated."
        redirect_to(groups_path)
    end
      
    def destroy
        @group = Group.find(params[:id])
        @group.destroy
        flash[:success] = "Group '#{@group.name}' deleted."
        redirect_to(groups_path)
    end  
      
      
    def adduser
        @group=Group.find(params[:id])
        @group_users = @group.get_users
        
        if params.has_key?(:operate)
          user = User.find_by_id(params[:operate])
          if @group_users.include?(user)
            @group.users.delete(user)
            flash[:success] = "#{user.name} was successfully deleted."
          else 
            @group.users << user
            flash[:success] = "#{user.name} was successfully added."
          end
          params.delete :operate
        end
        
        @group_users = @group.get_users
        
        update_session(:page, :query, :order)
        
        @users = find_conditional_users
    
        # update user accuracy fields
        if !params.has_key?(:page) && !params.has_key?(:query) && !params.has_key?(:order)
          @users.each { |user| user.update_attribute(:accuracy, user.get_accuracy) }
        end
        # byebug
    
        if @users == nil
          flash[:warning] = "No Results!"
        else
          # byebug
          @users = @users.paginate(per_page: 15, page: params[:page])
        end
        
    end
    
       
    public
    
    def group_params
        params.require(:group).permit(:name,:description,:group_level,:admin_uid)
    end
    

end