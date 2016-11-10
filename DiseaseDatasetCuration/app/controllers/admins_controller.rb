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
  
  
  def showgroups
    @all_groups = Group.all
    
  
  
  
  end
  
  
  
  
  
  
end
