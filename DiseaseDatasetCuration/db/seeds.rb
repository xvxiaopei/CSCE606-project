require 'csv'

# Diseases
# first 100 diseases
csv = CSV.read(Rails.root.join('lib', 'seeds', 'whole_rare_disease_list_result.csv'), { :col_sep => "\t"})
csv[0..99].each do |row|
    arr = ["disease",row[0],"accession",row[1]]
    Disease.create!(Hash[*arr])
end
# puts csv.to_s


# Users
# 102 users
User.create!(name: "666", email: "666@gmail.com", password: "foobar", password_confirmation: "foobar", admin: true)
(0..100).each {|i| User.create!(name: "mashuo#{i}", email: "mashuo#{i}@gmail.com", password: "19930521", password_confirmation: "19930521", admin: false)}


# Submissions
(0..5000).each do |i|
  puts i.to_s
  _user = User.find_by_id(rand(0..User.count-1))
  _disease = Disease.where(closed: false).order("RANDOM()").first
  _related = rand(0..2) == 0 ? true : false
  next if !_user || !_disease
  Submission.insert!(disease_id: _disease.id, user_id: _user.id, is_related: true, reason: 0) if _related
  Submission.insert!(disease_id: _disease.id, user_id: _user.id, is_related: false, reason: rand(1..7)) if !_related
end
