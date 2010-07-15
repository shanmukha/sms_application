class AcademicYear < ActiveRecord::Base
  belongs_to :school
  before_save :check_current

  validates_presence_of :from_date,:to_date,:identification_name,:school_id

  def check_current
    school = School.find(self.school_id)
    if self.current == true
       academic_years = school.academic_years
       academic_years.each do |academic_year|
         academic_year.update_attributes(:current => false)
       end
    end
  end
end
