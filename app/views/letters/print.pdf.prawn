counter = 0
 for student in @students
 box = pdf.bounds
pdf.bounding_box([0, pdf.bounds.top], :width => pdf.bounds.right - pdf.bounds.left ) do
pdf.font "Times-Roman"
    counter = counter + 1
    content = @letter.content
    content.gsub!(/@student/, student.name) 
    content.gsub!(/@parent/, student.contact_name)
    content.gsub!(/@address/, student.address)
    content.gsub!(/@Student/, student.name) 
    content.gsub!(/@Parent/, student.contact_name)
    content.gsub!(/@Address/, student.address)
    pdf.text "#{content}", :size => 12
    pdf.start_new_page if counter < @students.size
    content.gsub!(/#{student.name}/,'@student') 
    content.gsub!(/#{student.contact_name}/,'@parent') 
    content.gsub!(/#{student.address}/,'@address')
    end
end


