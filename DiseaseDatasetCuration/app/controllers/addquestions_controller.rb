class AddquestionsController < ApplicationController

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
      
      
       
    private
    
    def addquestion_params
        params.require(:addquestion).permit(:content,:answer)
    end
    
end