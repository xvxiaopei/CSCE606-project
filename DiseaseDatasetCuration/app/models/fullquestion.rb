class Fullquestion < ActiveRecord::Base
  require 'yaml'
  require 'csv'
  
  has_many :fullsubmissions
  has_many :users, :through => :fullsubmissions











end
