class AdminsController < ApplicationController
  include AdminsHelper
  before_action :admin?

  def show
    # byebug

    update_session(:page, :search, :sort)
    #get_answer
    @diseases = Disease.all
    # byebug
    
    submission=Submission.all
    submissioncount=Hash.new
    @diseases.each do |dis|
      submissioncount[dis.accession]=0
      if !submission.empty?
        submission.each do |sub|
          if sub.all_data.has_key?(dis.accession)
            submissioncount[dis.accession]=submissioncount[dis.accession]+1
          end
        end
      end
    end
    @subcount=submissioncount
    
  end


  def allusers
    update_session(:page, :query, :order)

    @users = find_conditional_users
        # byebug
    if @users == nil
      flash[:warning] = "No Results!"
    else
      # byebug
      get_answer
      @users.each { |user| user.get_accuracy }
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
      @group.users << @new_admin_4_grp
      flash[:success] = "Group Admin Identity for #{@group.name} Assigned successfully."
      redirect_to '/admin/manage_group_admins_groups'      
  end


  def promote
      #debugger
    if params.has_key?(:operate)
      user = User.find_by_id(params[:operate])
      
      #These lines of codes have hard-to-tell bugs, thus couldn't pass the test
      #The reason is mainly because that if you demote a group admin that he/she
      #is the admin of one group, then this group's admin_uid doesn't update.
      #Another case is similar
      #if user.group_admin
      #  user.update_attribute(:group_admin, false)
      #  user.update_attribute(:admin, false)
      #  flash[:success] = "#{user.name} was successfully demoted."
      #else 
      #  user.update_attribute(:group_admin, true)
      #  user.update_attribute(:admin, true)
      #  flash[:success] = "#{user.name} was successfully promoted."
      #end
      #params.delete :operate

      #So I substitute it with the following version:
      #Note that even though a group can only have one admin, doesn't mean a 
      #group admin cannot be admin of more than one groups.
      if user.group_admin
        #The demoting version:
        #First find out the groups this admin is in
        groups = user.groups
        #Then test if he/she is in charge of this grp, if so, reassign to 
        #power admin, otherwise leave it.
        groups.each do |grp|
            if grp.admin_uid == user.id
                grp.update_attribute(:admin_uid,
                User.find_by_admin_and_group_admin(true,false).id)  
            else
                ;
            end
        end
        #Finally update user's group_admin attr
        user.update_attribute(:group_admin, false)
        user.update_attribute(:admin, false)
        #This flash has bugs too.
        flash[:success] = "#{user.name} was successfully demoted."         
      else 
        #This line works well, for updating identity won't influence the grp he/she
        # is already in
        user.update_attribute(:group_admin, true)
        user.update_attribute(:admin, true)
        
        flash[:success] = "#{user.name} was successfully promoted."
      end
      params.delete :operate   
      redirect_to '/admin/promote'
      return
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

    gram=Hash.new
    gram=[{"name" => "correct","data" => {}},{"name" => "total","data" => {}},]
    questions.each do |k,a|
      gram[0]['data'][k]=0
      gram[1]['data'][k]=0
    end
    
    @histogram=Hash.new
    submission=Submission.all
    if !submission.empty?
      submission.each do |sub|
        if sub.all_data.has_key?(accession)
          answer=sub.all_data[accession]
          answer.each do |q,a|
            gram[1]['data'][q]=gram[1]['data'][q]+1
            if (questions[q].to_i>0 and a.to_i>0)or(questions[q].to_i<0 and a.to_i<0)
              gram[0]['data'][q]=gram[0]['data'][q]+1
            end
          end
        end
      end
      
      #@histogram=correct_answers
      @histogram=gram
      #@histogram=[{"name" => "correct","data" => {"Gender" => 10,"aaa" => 30}},{"name" => "total","data" => {"Gender" => 20,"aaa" => 20}}]
    end
  end

  def statistics
    p params[:group_id]
    @group=Group.find_by_id(params[:group_id])
    @users=@group.get_users
    if @users==nil
      flash[:warning] = "No User in this group!"
      redirect_to '/profile'
      return
    end
    get_answer
    @users.each { |user| user.get_accuracy }
    @accuracies=Hash.new
    num=0
    while num.to_f<10 do
      @accuracies[num]=0;
      num+=1
    end
    @users.each do |usr|
      if Submission.find_by_user_id(usr.id)!=nil
        accuracy=Submission.find_by_user_id(usr.id).accuracy
        if accuracy==1
          @accuracies[9]+=1
        else
         accuracy*=10
         accuracy=accuracy.floor
         @accuracies[accuracy]+=1
        end
      end
    end
    @statistic=Hash.new
    @accuracies.each do |a,n|
      tmp=(a.to_f/10).round(1)
      @statistic[tmp.to_s+" to "+(tmp+0.1).round(1).to_s]=n.to_i
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