class AddquestionsController < ApplicationController
    include AddquestionsHelper
    def new
#       @addquestion=Addquestion.new
    end
    
    def create
#       @addquestion=Addquestion.new(addquestion_params)
#       if @addquestion.save
#           flash[:success] = "#{@addquestion.content} was successfully created."
#            redirect_to addquestions_path
#       else
#           render 'new'
#       end
        if (defined? @@all_addquestions)&&@@all_addquestions!=nil
          if params[:content]!=""  
            if params[:answer]!=""
                @@all_addquestions[params[:content]]=params[:answer].to_i
            else
                @@all_addquestions[params[:content]]=0
            end
          end
        end
        redirect_to addquestions_path
    end
    
    
    
    def index
        if (!defined? @@all_addquestions)||@@all_addquestions==nil
            @@all_addquestions=Hash.new
        end
        if (!defined? @@group)||@@group==nil
            @all_groups = Group.all
            @@group=Array.new
            @all_groups.each do |grp|
                @@group << grp["name"]
            end
        end
        @all_groups=@@group
        @addquestions = @@all_addquestions
        p 'addquestion-------------------------'
        p @addquestions
        #debugger
    end
    
    def edit
#        @addquestion=Addquestion.find(params[:id])
    end
    
#    def update
        
#        @addquestion=Addquestion.find params[:id]
#        @addquestion.update_attributes!(addquestion_params)
#        flash[:success]="#{@addquestion.contennt} was successfully updated."
#        redirect_to(addquestions_path)
#    end
      
    def destroy
        @@all_addquestions.delete(params[:key])
        redirect_to :back
#        @addquestion=Addquestion.find(params[:id])
#        @addquestion.destroy
#        flash[:success] = "Question '#{@addquestion.content}' deleted."
#        redirect_to(addquestions_path)
    end  
      
  def search
     if (defined?@@dataset_global)&&@@dataset_global!=nil
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
 
  
  def submit_result
    if @@all_addquestions.empty?
        flash[:warning] = "Please add new questions!"
        redirect_to addquestions_path
        return
    end
    if (!defined?@@dataset_global)||(@@dataset_global==nil)||@@dataset_global.empty?
        flash[:warning] = "Please choose data_set!"
        redirect_to '/addquestion/search'
        return
    end
    @dataset=Dataset.find_by_name("dataset")
    @@dataset_global.each do |k,v|
        @dataset.data_in(k,v)
    end
    @dataset.save
    @datahash=Hash.new
    @dataarray=Array.new
    @@dataset_global.each do |k,v|
        @dataarray << k
        @disease=Disease.new
        @disease.accession=k
        @disease.disease=v
        @disease.questions=@@all_addquestions
        @disease.save
    end
    @@group.each do |grp|
        @GRP=Group.find_by_name(grp)
        @dataarray.each do |d|
            @GRP.data_set << d
        end
        @GRP.save
    end
    @@all_addquestions=nil
    @@dataset_global=nil
    @@group=nil
    redirect_to '/profile'
  end
  
  def delete_dataset
    @@dataset_global.delete(params[:key])
    redirect_to :back
  end
  
  def delete_group
    @@group.delete(params[:key])
    redirect_to :back
  end
  
  
   def show
    @groups=Group.all
   end
  
  def delete_in_show
      @disease=Disease.find_by_accession(params[:key])
      if @disease!=nil
        @disease.destroy
      end
      @dataset=Dataset.find_by_name("dataset")
      @dataset.data_delete(params[:key])
      @dataset.save
      @group=Group.all
      @group.each do |grp|
          grp.data_set.delete(params[:key])
          grp.save
      end
      @submissions=Submission.all
      @submissions.each do |submission|
          if submission.all_data.has_key?(params[:key])
              submission.all_data.delete(params[:key])
          end
          if submission.all_data.empty?
              submission.destroy
          else
              submission.save!
          end
      end
      redirect_to :back
  end
       
    private
    
    def addquestion_params
        params.require(:addquestion).permit(:content,:answer)
    end
    
    
end