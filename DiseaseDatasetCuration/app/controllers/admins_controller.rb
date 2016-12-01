class AdminsController < ApplicationController
  include AdminsHelper
  before_action :admin?

  def show
    # byebug

    update_session(:page, :search, :sort)

    @diseases = Disease.all
    # byebug

=begin
    if @diseases == nil
      flash[:warning] = "No Results!"
    else
      # byebug
      @diseases = @diseases.paginate(per_page: 15, page: params[:page])
    end
=end
  end


  def allusers
    update_session(:page, :query, :order)

    @users = find_conditional_users
#    @users.each do |u|
#      u.renew_data
#    end
    # update user accuracy fields
#    if !params.has_key?(:page) && !params.has_key?(:query) && !params.has_key?(:order)
      get_answer
      @users.each { |user| user.get_accuracy }
#    end
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

    accession=params[:accession]
    questions=params[:questions]

    correct_answers=Hash.new
    questions.each do |k,a|
      p k
      correct_answers[k+' correct']=0
      correct_answers[k+' total']=0
    end
    
    @histogram=Hash.new
    
    submission=Submission.all
    if !submission.empty?
      submission.each do |sub|
        if sub.all_data.has_key?(accession)
          answer=sub.all_data[accession]
          answer.each do |q,a|
            correct_answers[q+' total']=correct_answers[q+' total']+1
            if (questions[q].to_i>0 and a.to_i>0)or(questions[q].to_i<0 and a.to_i<0)
              correct_answers[q+' correct']=correct_answers[q+' correct']+1
            end
          end
        end
      end
      @histogram=correct_answers
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
    
  
end