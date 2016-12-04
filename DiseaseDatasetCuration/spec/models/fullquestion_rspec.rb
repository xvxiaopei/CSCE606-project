require 'rails_helper'

describe Fullquestion do
    
    #Test Associations and Validations
    describe "Associations + Validations" do

       
        it "associations" do
          assc1 = Fullquestion.reflect_on_association(:fullsubmissions)
          assc2 = Fullquestion.reflect_on_association(:users)
          #debugger
          expect(assc1.macro).to eq :has_many 
          expect(assc2.macro).to eq :has_many
          expect(assc2.through_reflection.name).to eq :fullsubmissions
        end

        it "validations" do
        end

    end
    
    #Test Fullquestion.convert_ans
    describe "Convert DB answer string to meaningful 'Yes/No/Not Given' options" do
        fixtures :users
        fixtures :groups
        fixtures :fullquestions
        before(:each) do
          #Group operations    
          User.find_by_id(1).groups << Group.find_by_id(1)
          User.find_by_id(2).groups << Group.find_by_id(2)
          User.find_by_id(3).groups << Group.find_by_id(3)
          #Question opearations

        end
        
        
        
        
        
    end
    
    
    
    
    
    
    
    
    
    
end
