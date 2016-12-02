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
            selected_accession_keys = params[:selected_keys]
            temp_record_id = params[:user][:temppsr_id]
            @temp_record = Partsearchresult.find(temp_record_id)
            
            #For View Use
            @show_selected_keyword  = @temp_record.keyword
            @show_selected_datasets = Hash.new
            selected_accession_keys.each do |key|
                
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
            
            
        end
    end
    
    
    
    
    
    
    
    
    
    
    
    def show
        #debugger
    end
    
    
    
    
end