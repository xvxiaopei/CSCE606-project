class FullsubmissionsController < ApplicationController
    include AdminsHelper
    before_action :admin?




    def index
        
        #debugger
        @fullsubmissions = Fullsubmission.all
        
    end
    








end