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
    if Submission.find_by_user_id(session[:user_id])!=nil
      @submission=Submission.find_by_user_id(session[:user_id]).all_data
    else 
      @submission=Hash.new
    end
  end

  def import
    # byebug
    user_id = session[:user_id]
  	choose = params[:choose]
    
    if choose == nil
      flash[:warning] = "No answer given!"
      redirect_to '/diseases'
      return
    end
    
    all_data=Hash.new
    choose.each do |dandq,answer|
      dandq=eval dandq
      dandq.each do |d,q|
        if all_data.has_key?(d)
          all_data[d][q]=answer
        else
          all_data[d]={q=>answer}
        end
      end
    end
    #p 'before submission----------------------------'
    #p all_data
    insert!(user_id,all_data)
    flash[:success] = "Successfully submitted."

    redirect_to '/profile'
  end

end
