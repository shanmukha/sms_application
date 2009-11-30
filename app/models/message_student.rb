class MessageStudent < ActiveRecord::Base
 belongs_to :student
 belongs_to  :message
end
