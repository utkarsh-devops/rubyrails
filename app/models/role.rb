class Role < ActiveRecord::Base
  attr_accessible :role_description

  def display_name
    self.role_description
  end

  def self.get_role_id str
    self.select("id").where(:role_description=> str).first.id
  end
end
