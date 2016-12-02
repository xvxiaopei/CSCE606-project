class Submission < ActiveRecord::Base
#  require 'yaml'

  serialize :all_data,Hash
#  belongs_to :disease
#  belongs_to :user
  
#  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :count, presence: true
  validates :accuracy, presence: true
  validates :num_correct, presence: true
  
  def self.insert!(user_id,data)
    # byebug
    submission=Submission.find_by_user_id(user_id)
    if submission==nil
      submission=Submission.new
      submission.user_id=user_id
      submission.save
    end
    alldata=submission.all_data
    data.each do |accession,questions|
      alldata[accession]=questions
    end

    submission.save
    #p 'after submission----------------------------'
    #p Submission.find_by_user_id(user_id).all_data
  end

  def get_accuracy
    # byebug
      all_data=self.all_data
      total_submission=0
      total_question=0
      right_question=0
      all_data.each do |accession,questions|
        disease=Disease.find_by_accession(accession)
        standard_answer=disease.questions
        questions.each do |k,v|
          if v.to_i*standard_answer[k].to_i>0
            right_question=right_question+1
          end
          total_question=total_question+1
        end
        total_submission=total_submission+1
      end
      self.num_correct=right_question
      self.accuracy=right_question.to_f/total_question.to_f
      self.count=self.all_data.size
    return self.accuracy
  end

end
