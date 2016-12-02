class FullquestionsController < ApplicationController
    include FullquestionsHelper
    include AdminsHelper
    before_action :admin?
    
    def search
        #debugger
    
    
    
    
    end
    
    def performsearch
        
        #This func do two things: get result back from API 
        #+ save result to DB[partsearchresult]
        if(params[:search])
            debugger
            n_keyword = params[:search]
            
            @previous_record = Partsearchresult.where(:keyword => n_keyword)
            if @previous_record.count > 0
                
                @dataset = @previous_record.Data_set_results;
            else
                @dataset_raw = search_from_arrayexpress(params[:search])
                
                Partsearchresult.create(keyword: n_keyword, Data_set_results: @dataset_raw)
                
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
        end
        
    
    
    
        render 'search'
    end
    
    
    def show
        #debugger
    end
    
    
    
    
end