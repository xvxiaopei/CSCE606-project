class AddquestionsController < ApplicationController
    include AddquestionsHelper
    def new
        @addquestion=Addquestion.new
    end
    
    def create
       @addquestion=Addquestion.new(addquestion_params)
       if @addquestion.save
           flash[:success] = "#{@addquestion.content} was successfully created."
            redirect_to addquestions_path
       else
           render 'new'
       end
    end
    
    
    
    def index
        
        @all_addquestions = Addquestion.all
        #debugger
    end
    
    def edit
        @addquestion=Addquestion.find(params[:id])
    end
    
    def update
        
        @addquestion=Addquestion.find params[:id]
        @addquestion.update_attributes!(addquestion_params)
        flash[:success]="#{@addquestion.contennt} was successfully updated."
        redirect_to(addquestions_path)
    end
      
    def destroy
        @addquestion=Addquestion.find(params[:id])
        @addquestion.destroy
        flash[:success] = "Question '#{@addquestion.content}' deleted."
        redirect_to(addquestions_path)
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
       if Dataset.find_by_name("dataset")==nil
         Dataset.create(name: "dataset")
       end
       @previous_data=Dataset.find_by_name("dataset")  
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
       @dataset=@@dataset_global
     end
  end
 
  def confirm_search
    @dataset=Dataset.find_by_name("dataset")
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
    redirect_to '/index'
  end
  
  def delete_dataset
    @@dataset_global.delete(params[:key])
    redirect_to :back
  end
   
       
    private
    
    def addquestion_params
        params.require(:addquestion).permit(:content,:answer)
    end
    
    
end