box = pdf.bounds
counter = 0
y_val = box.top - 42

for data in @students
  counter = counter + 1
  
  name = data.parent
  address = data.address

  case counter % 3 
       when 1 then left = box.left + 19
       when 2 then left = box.left + 213
       when 0 then left = box.left + 404
  end

  pdf.bounding_box([left, y_val], :width => 200) do
    pdf.text name
    pdf.text address
  end

  y_val = y_val - 70 if counter % 3 == 0

  if counter == 30
    pdf.start_new_page 
    counter = 0
    y_val = box.top - 42
  end
end
