module MessagesHelper
  def column_class(status)
      class_name = case status
                     when "Sent" then "yellow"
                     when "Delivered" then "green"
                     when "Failed" then "red"
                     when "Invalid mobile number" then 'orange'
                     else 'red'
         end
        return class_name
  end

 def disabled(status)
   disable = case status
              when "Sent" then true
              when "Delivered" then true
              when "Failed" then false
              when "Invalid mobile number" then false
              else 'red'
         end
    return disable
 end
end
