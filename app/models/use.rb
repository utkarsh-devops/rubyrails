class Use < ActiveRecord::Base
  attr_accessible :description

  validates :description, presence: true
  scope :not_deleted,   -> { where(:is_deleted => :false) }
  def display_name
    self.description
  end
end
