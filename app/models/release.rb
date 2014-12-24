class Release < ActiveRecord::Base
  attr_accessible :english_desc, :spanish_desc, :version

  def display_name
    self.id.to_s
  end
end
