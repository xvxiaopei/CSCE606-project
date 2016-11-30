class Submission < ActiveRecord::Base
  require 'yaml'
  serialize :all_data,Hash
  belongs_to :disease
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true


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
  end

end
