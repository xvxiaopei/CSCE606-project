class GroupsController < ApplicationController
    include GroupsHelper
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
      
      
       
    public
    
    def group_params
        params.require(:group).permit(:name,:description,:group_level,:admin_uid)
    end
    

end