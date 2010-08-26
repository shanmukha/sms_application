class MessageTemplate < ActiveRecord::Base
 belongs_to :user
 belongs_to :tag
 validates_presence_of  :message_body,:message_title,:tag_id
fires :new_message_template, :on => :create, :actor => :user
fires :edit_message_template, :on => :update, :actor => :user
end
