class GroupsController < ApplicationController
    include GroupsHelper
    before_action :admins?
    
    
    def index
        
        @all_groups = Group.all
        #debugger
    end
    
    def edit
        @group=Group.find(params[:id])
    end
    
    def update
        
        @group=Group.find params[:id]
        @group.update_attributes!(group_params)
        flash[:now]="#{@group.name} was successfully updated."
        redirect_to(groups_path)
    end
      
    def destroy
        @group = Group.find(params[:id])
        @group.destroy
        flash[:notice] = "Group '#{@group.name}' deleted."
        redirect_to(groups_path)
    end  
      
      
       
    private
    
    def group_params
        params.require(:group).permit(:name,:description,:group_level)
    end
    

end