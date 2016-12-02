class FullquestionsController < ApplicationController
    include FullquestionsHelper
    include AdminsHelper
    before_action :admin?
    
    def search
        #debugger
        @poweradmin = current_user
    
    
    
    end
    
    def performsearch
        @poweradmin = current_user
        #This func do two things: get result back from API 
        #+ save result to DB[partsearchresult]
        if(params[:search])
            #debugger
            n_keyword = params[:search]
            
            @previous_record = Partsearchresult.where(:keyword => n_keyword)
            if @previous_record.count > 0
                @new_temp_record = @previous_record.first
                @dataset = @previous_record.first.Data_set_results
            else
                @dataset_raw = search_from_arrayexpress(params[:search])
                if(n_keyword != "")
                    @new_temp_record = Partsearchresult.create(keyword: n_keyword, Data_set_results: @dataset_raw)
                end
                dataset_foruse = Hash.new
                
                @dataset_raw.each do |k,v|
                  dataset_foruse[k] = v
                  if dataset_foruse.length >= 20
                    break
                  end
                end                
                
                @dataset = dataset_foruse    
                
            end
        
        else
            redirect_to full_search_path
            return
        end
        
    
        render 'search'
    end
    
    
    def groupselect
        #debugger
        if(!params.has_key?(:selected_keys))
            flash[:warning] = "Please select a Dataset"
            redirect_to full_search_path
            return
        else
            #Receive primary params
            @selected_accession_keys = params[:selected_keys]
            
            
            temp_record_id = params[:user][:temppsr_id]
            @temp_record = Partsearchresult.find(temp_record_id)
            
            #For View Use
            @show_selected_keyword  = @temp_record.keyword
            @show_selected_datasets = Hash.new
            @selected_accession_keys.each do |key|
                
                @show_selected_datasets[key] = @temp_record.Data_set_results[key]
            end
            @poweradmin = current_user
            
            #Display groups
            if !current_user.group_admin?      #main admin
                @all_groups = Group.all
            else 
                @all_groups = Group.where("admin_uid = ?", current_user.id)
            end            
            
            #Questions
            @ans = ['Yes','No','Not Given']
            
            @full_question = Fullquestion.new
            
        end
    end
    
    
    def create
        
        debugger
        
        #Two things to do:
        #First save a fullquestion to the DB
        
        #Two fields on question
        question_desc = params[:qcontent]
        question_ans  = params[:selected_ans].first
        
        #Two on Dataset
        concerned_dataset_keys = params[:fullquestion][:sakeys].split(' ')
        partsearchresult = Partsearchresult.find(params[:fullquestion][:temppsr_id])
        
        #One about the Group
        selected_grp_ids = params[:selected_grp_ids]
        
        #Now Create them:
        
        concerned_dataset_keys.each do |dataset_accession|
            dataset_name = partsearchresult.Data_set_results[dataset_accession]
            
            new_fullquestion = Fullquestion.create!(:qcontent => question_desc,
                            :qanswer => question_ans, :ds_accession => dataset_accession, 
                            :ds_name => dataset_name)
            #Second create submissions and assign them to users of different groups
            assign_question_to_group_users(new_fullquestion.id,selected_grp_ids)        
        end
        
        
        redirect_to fullquestions_path

    end
    
    
    def index
        @fullquestions = Fullquestion.all
    end
    
    
    
    
    
    def show
        #debugger
    end
    
    private
    
    def assign_question_to_group_users(question_id,group_ids)
        
        group_ids.each do |grp_id|
            
            grp = Group.find(grp_id)
            grp_users = grp.get_users
            
            #user has many fullquestions through submisssions
            grp_users.each do |user|
                
                user.fullquestions << Fullquestion.find(question_id)
                
            end
            
        end
        
    
    end
    
end