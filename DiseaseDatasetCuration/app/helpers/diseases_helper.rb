module DiseasesHelper
  include ApplicationHelper
  def insert!(all_data)
    # byebug
    if !all_data.empty?
      all_data.each do |data|
        
        submission_this_id=Fullsubmission.where(:user_id => data["user_id"])
        submission_this_id_ques=submission_this_id.find_by_fullquestion_id(data["fullquestion_id"])
        question=Fullquestion.find_by_id(data["fullquestion_id"])
        if submission_this_id_ques.choice==nil
          if data["choice"]=='1'
            question.yes_users=question.yes_users+1
          else
            question.no_users=question.no_users+1
          end
        elsif submission_this_id_ques.choice=='1'
          if data["choice"]=='2'
            question.yes_users=question.yes_users-1
            question.no_users=question.no_users+1
          end
        elsif submission_this_id_ques.choice=='2'
          if data["choice"]=='1'
            question.yes_users=question.yes_users+1
            question.no_users=question.no_users-1
          end
        end
        if question.yes_users<0
          question.yes_users=0
        end
        if question.no_users<0
          question.no_users=0
        end
        question.save!
        submission_this_id_ques.choice=data["choice"]
        submission_this_id_ques.reason=data["reason"]
        submission_this_id_ques.save!
        
        submission_this_id=Fullsubmission.where(:user_id => data["user_id"])
        submission_this_id_ques=submission_this_id.find_by_fullquestion_id(data["fullquestion_id"])
        question=Fullquestion.find_by_id(data["fullquestion_id"])
        #, :fullquestion_id => data["fullquestion_id"], :choice => data["choice"], :reason => data["reason"])
      end
    end
  
  end

end
