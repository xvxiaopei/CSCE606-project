module DiseasesHelper
  include ApplicationHelper
  def insert!(user_id,data)
    # byebug

    if Submission.find_by_user_id(user_id)==nil
       submission=Submission.create(:user_id => user_id)
    else
       submission=Submission.find_by_user_id(user_id) 
    end
    alldata=submission.all_data
    data.each do |accession,questions|
      alldata[accession]=questions
    end
    submission.save!
  end

end
