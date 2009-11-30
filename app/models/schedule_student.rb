class ScheduleStudent < ActiveRecord::Base
 belongs_to :student
 belongs_to :schedule
end
