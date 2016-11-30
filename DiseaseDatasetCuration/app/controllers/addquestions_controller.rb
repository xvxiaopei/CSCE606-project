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
        if defined? @@all_addquestions
            if params[:answer]!=""
              if params[:answer]=="yes"
                  @@all_addquestions[params[:content]]=1
              else
                 @@all_addquestions[params[:content]]=-1
              end
            else
                @@all_addquestions[params[:content]]=0
            end
        end
        redirect_to addquestions_path
    end
    
    
    
    def index
        if !defined? @@all_addquestions
            @@all_addquestions=Hash.new
        end
        if !defined? @@group
            @all_groups = Group.all
            @@group=Array.new
            @all_groups.each do |grp|
                @@group << grp["name"]
            end
        end
        @all_groups=@@group
        @addquestions = @@all_addquestions
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
 
  
  def submit_result
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
        @GRP.data_set=@dataarray
        @GRP.save
        p @GRP.name
    end
#    @disease_all=Disease.all
#    @disease_all.each do |d|
#        p d.accession
#    end
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
    if Dataset.find_by_name("dataset")!=nil
        @dataset=Dataset.find_by_name("dataset").Data_set
        @diseases=Hash.new
        @dataset.each do |k,v|
            @dis=Disease.find_by_accession(k)
            if @dis!=nil
                @diseases[k]=@dis.questions 
            end
        end
     else
        @diseases=nil
     end
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
      redirect_to :back
  end
       
    private
    
    def addquestion_params
        params.require(:addquestion).permit(:content,:answer)
    end
    
    
end