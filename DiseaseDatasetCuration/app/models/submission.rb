class Submission < ActiveRecord::Base
  require 'yaml'

  belongs_to :disease
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :disease_id, presence: true
  validates :reason, presence: true
  validates_inclusion_of :is_related, in: [true, false]


  def self.insert!(new_entry)
    # byebug
    disease = Disease.find_by_id(new_entry[:disease_id])

    if new_entry[:is_related]
      num = disease.related
      disease.update!(related: num+1)
    else
      num = disease.unrelated
      disease.update!(unrelated: num+1)
    end

    Submission.create!(new_entry)
    data = YAML.load_file parameters_yaml_path
    closing_threshold = data["closing_threshold"]
    dist_threshold = data["dist_threshold"]

    total = disease.related + disease.unrelated
    if total >= closing_threshold && ( disease.related.to_f / total.to_f >= dist_threshold || disease.unrelated.to_f / total.to_f >= dist_threshold )
      disease.update!(closed: true)
    end
  end

  def self.parameters_yaml_path
    return "./config/parameters.yml"
  end
end
