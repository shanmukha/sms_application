class School < ActiveRecord::Base
   has_many :groups
   belongs_to :administrator, :class_name => 'User'
   accepts_nested_attributes_for :administrator
end
