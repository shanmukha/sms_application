class Subject < ActiveRecord::Base
 belongs_to :user
 belongs_to :group
 has_many :marks
 validates_presence_of :name
 validates_presence_of :group_id , :message => 'Please select a class'
end
