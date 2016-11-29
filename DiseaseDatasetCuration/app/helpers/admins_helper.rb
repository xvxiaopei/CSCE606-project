module AdminsHelper
  include ApplicationHelper
  require 'yaml'
  require 'net/http'
  require 'json'
 
  def get_num_per_page
    data = YAML.load_file parameters_yaml_path
    return data[:num_item_per_page.to_s]
  end

  def set_num_per_page(new_value)
    data = YAML.load_file parameters_yaml_path
    data[:num_item_per_page.to_s] = new_value
    File.open(parameters_yaml_path, 'w') { |f| YAML.dump(data, f) }
  end


  def admin?
    user = User.find_by_id(session[:user_id])
    if !user || !user.admin?
      flash[:warning] = "Permission denied!"
      redirect_to root_path
      return
    end
  end


  def find_conditional_diseases
    query = session[:search]
    sort = session[:sort]

    if !query.nil?
      if (query =~ /^E-.*$/) != nil
        diseases = Disease.where(:accession => query)
      else (query =~ /^\w+/) != nil
        diseases = Disease.where(:disease => query)
      end
    else
      diseases = Disease.all
    end

    return diseases if sort.nil?
    which_way = sort[1] ? " DESC" : " ASC"
    sort_criteria = (sort[0] == "submission" ? ('related + unrelated ' + which_way) : {sort[0] => (sort[1] ? :desc : :asc)})
    diseases = diseases.order(sort_criteria)

    return diseases
  end



  def find_conditional_users
    query = session[:query]
    order = session[:order]

    if !query.nil?
      users = User.where(email: query)
    else
      users = User.all
    end

    return users if order.nil?

    which_way = order[1] ? " DESC" : " ASC"
    case order[0]
    when "id"
      users = users.order("id" + which_way)
    when "sub"
      users = users.joins(:submissions).group("users.id").order("count(users.id)" + which_way)
    when "closed_sub"
      users = users.joins(:submissions).joins("LEFT JOIN diseases on diseases.id = submissions.disease_id").where("diseases.closed = ?", true).group("users.id").order("count(users.id)" + which_way)
    when "correct"
      users = users.joins(:submissions).joins("LEFT JOIN diseases on diseases.id = submissions.disease_id").where("diseases.closed = ?", true).where('diseases.closed =?', true).where('(submissions.is_related =? and diseases.related > diseases.unrelated) or (submissions.is_related =? and diseases.unrelated > diseases.related)', true, false).group("users.id").order("count(users.id)" + which_way)
    when "accuracy"
      users = users.order("accuracy" + which_way)
      # comment the upper statement if you find it too slow to fetch the all user page
    end

    return users
  end

  def search_from_arrayexpress(keywords)
    url = 'https://www.ebi.ac.uk/arrayexpress/json/v3/experiments?keywords='+keywords;
#   p url
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data_hash=JSON.parse(response)
    data_result=Hash.new
    data_hash["experiments"]["experiment"].each {|value|
    data_result[value["accession"]]=value["name"]
    }
#    data_result=Hash.new
#    data_result["E-GEOD-57691"]="Differential gene expression in human abdominal aortic aneurysm and atherosclerosis"
#    data_result["E-MTAB-3175"]="Gene expression study in Positron Emission Tomography (PET) positive abdominal aortic aneurysms"
    return data_result
  end
  
  def index_to_reason(num)
    case num
    when 0
      return "Related"
    when 1
      return "Comprehensive"
    when 2
      return "Irrelevant Study"
    when 3
      return "Not Enough Experiment"
    when 4
      return "No health Control"
    when 5
      return "Micro RNA"
    when 6
      return "Biomarker"
    when 7
      return "Others"
    end

  end
end