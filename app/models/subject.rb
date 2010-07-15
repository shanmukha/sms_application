class Subject < ActiveRecord::Base
 belongs_to :user
 belongs_to :group
 has_many :marks
 validates_presence_of :name
end
