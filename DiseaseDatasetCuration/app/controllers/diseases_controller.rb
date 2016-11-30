class DiseasesController < ApplicationController
  include DiseasesHelper
  include SessionsHelper

  def index
    # byebug
    if !logged_in?
      flash[:warning] = "Please Log in!"
      redirect_to root_path
      return
    end

    user = User.find(session[:user_id])
    group=user.groups
    if group.any?
      @dataset=[];
      group.each do |g|
        g.data_set.each do |d|
          @dataset << d
        end
      end
      @dataset=@dataset.uniq
      
      @diseases=[]
      @dataset.each do |ds|
        @diseases << Disease.find_by_accession(ds)
      end
    else
      @diseases=[]
    end
  
  end

  def import
    # byebug
    user_id = session[:user_id]
  	choose = params[:choose]
  	reason = params[:reason]
    diseases = params[:dis]

    if choose == nil
      flash[:warning] = "No answer given!"
      redirect_to '/diseases'
      return
    end

    choose.keys.each do |d_id|
      # byebug
      if choose_to_bool(choose[d_id])
        Submission.insert!({:disease_id => d_id, :user_id => user_id, :is_related => choose_to_bool(choose[d_id]), :reason => 0})
      else
        Submission.insert!({:disease_id => d_id, :user_id => user_id, :is_related => choose_to_bool(choose[d_id]), :reason => reason_to_index(reason[d_id])});
      end
    end

    flash[:success] = "Successfully submitted #{choose.keys.size} questions."
    redirect_to '/diseases'
  end

end
