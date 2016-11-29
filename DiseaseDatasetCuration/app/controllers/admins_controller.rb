class AdminsController < ApplicationController
  include AdminsHelper
  before_action :admin?

  def show
    # byebug

    update_session(:page, :search, :sort)

    @diseases = find_conditional_diseases
    # byebug

    if @diseases == nil
      flash[:warning] = "No Results!"
    else
      # byebug
      @diseases = @diseases.paginate(per_page: 15, page: params[:page])
    end
  end

  def statistics
    @user = User.find_by_id(1)
  end

  def allusers
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

  def promotewithgroup
      #All groups
      @poweradmin=current_user
      @all_groups = Group.all
      #debugger
  end


  def performassigngroup
      @group=Group.find(params[:id])
      #This action won't influence the identity of admins
      
      #Step: Arrange new admin
      if(params.has_key?(:user_ids))
        id=params.require(:user_ids)
      else
          flash[:warning] = "Please select a user!"
          redirect_to '/admin/promotewithgroup'
          return
      end
        
      @new_grp_admin=User.find_by_id(id[0])
      
      #3 situations: normal user; already grpadmin but in other grp; poweradmin
      if(@new_grp_admin.admin == true && @new_grp_admin.group_admin == false)
          #power admin -- do nothing
      elsif (@new_grp_admin.admin == true && @new_grp_admin.group_admin == true)
          #group admin -- do nothing
      else
          #User -- promote to be a group admin and assign him this group
          @new_grp_admin.update_attribute(:group_admin,true)
          @new_grp_admin.update_attribute(:admin,true)
      end
      @group.update_attribute(:admin_uid,id[0])
      flash[:success] = "Group Admin Identity for #{@group.name} Assigned successfully."
      redirect_to '/admin/promotewithgroup'
  end

  def managegrps
      #All groups
      @poweradmin=current_user
      @all_groups = Group.all      
      @all_grp_admins = User.where(:admin => true, :group_admin => true)
      #debugger
  end

  def rearrange
      #debugger
      @group=Group.find(params[:id])
      #This action will change grp admin
      #Step: Arrange new admin
      if(params.has_key?(:gadmin_ids))
        id=params.require(:gadmin_ids)
      else
          flash[:warning] = "Please select an admin!"
          redirect_to '/admin/manage_group_admins_groups'
          return
      end
        
      @new_admin_4_grp=User.find_by_id(id[0])
      @group.update_attribute(:admin_uid,id[0])
      flash[:success] = "Group Admin Identity for #{@group.name} Assigned successfully."
      redirect_to '/admin/manage_group_admins_groups'      
  end







  def promote
    if params.has_key?(:operate)
      user = User.find_by_id(params[:operate])
      if user.group_admin
        user.update_attribute(:group_admin, false)
        user.update_attribute(:admin, false)
        flash[:success] = "#{user.name} was successfully demoted."
      else 
        user.update_attribute(:group_admin, true)
        user.update_attribute(:admin, true)
        flash[:success] = "#{user.name} was successfully promoted."
      end
      params.delete :operate
    end
      
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

  def configuration
    user = User.find_by_id(session[:user_id])
    if !user || !user.admin?
      flash[:warning] = "Permission denied!"
      redirect_to root_path
      return
    end
  end


  def histogram

    @dis_id = params[:sort]
    @histogram_data = {}

    for i in 0..7
      @histogram_data[index_to_reason(i)] = Submission.where("disease_id = '#{@dis_id}'").where("reason = #{i}").count
    end

  end


  def getcsv
    @dis = Disease.where(:closed => true)
    respond_to do |format|
      format.html
      format.csv { send_data @dis.to_csv }
      format.tsv { send_data @dis.to_csv(col_sep: "\t") }
    end
  end


  def config_update
    user = User.find_by_id(session[:user_id])
    if !user || !user.admin?
      flash[:warning] = "Permission denied!"
      redirect_to root_path
      return
    end

    str = params[:num_per_page]

    if str.size == 0 || (str =~ /^[-+]?\d+$/) == nil
      flash[:warning] = "Invalid input!"
      redirect_to '/config'
      return
    end

    new_value = params[:num_per_page].to_i

    if new_value < 5 || new_value > 20
      flash[:warning] = "Please enter a number in range (5..20)"
      redirect_to '/config'
      return
    end

    old_value = get_num_per_page
    set_num_per_page(new_value)
    flash[:success] = "Number of entries per page successfully switched from #{old_value} to #{new_value}"
    redirect_to '/config'
  end
    
  def search
    if defined? @@dataset_global
      @dataset=@@dataset_global
    end
    user = User.find_by_id(session[:user_id])
    if !user || !user.admin?
      flash[:warning] = "Permission denied!"
      redirect_to root_path
    elsif params[:search]
       @dataset = search_from_arrayexpress(params[:search])
       @@dataset_global=Hash.new
       if Dataset.find_by_name(params[:search])==nil
         Dataset.create(name: params[:search])
       end
       @previous_data=Dataset.find_by_name(params[:search])  
       @dataset.each do |k,v|
         if !@previous_data.data_has_key(k)
           @@dataset_global[k]=v
         end
         if @@dataset_global.length>=20
           break
         end
       end
       if @@dataset_global.length==0
         flash[:warning] = "Can't find new dataset!"
       end
       @@search_id=params[:search]
       @dataset=@@dataset_global
    end
  end
 
  def confirm_search
    @dataset=Dataset.find_by_name(@@search_id)
    @@dataset_global.each do |k,v|
#      if !Dataset.data_has_key(k)&&v[1]>0
        @dataset.data_in(k,v)
#      end
    end
    @dataset.save
#    @@dataset_global.each do |k,v|
#      if v[1]<0
#          @@dataset_global[k]=v
#      end
#    end
    redirect_to :back
  end
  
  def delete_dataset
    @@dataset_global.delete(params[:key])
    redirect_to :back
  end
  
#    def confirm_search
#    if defined? @@dataset_global
#      if File.exist?("lib/dataset.yml")
 #      @previous_data = YAML.load_file("lib/dataset.yml")
#      @@dataset_global.each do |k,v|
#         if !@previous_data.has_key?(k)&&v[1]>0
#           @previous_data[k]=v
#         end
#       end
#      else 
 #       @@dataset_global.each do |k,v|
 #        if v[1]>0
 #          @previous_data[k]=v
#         end
#       end
 #     end
#      File.open("lib/dataset.yml","w") do |file|
#       file.write @previous_data.to_yaml
#     end
 #   end
 #   redirect_to :back
#  end
#  def search_data
#      if params[:search]
#        flash[:warning] = "Loading..."
 #       @dataset = search_from_arrayexpress(params[:search])
#         @dataset=["1","ok"]
 #        redirect_to :back
 #     end
 # end
  
end