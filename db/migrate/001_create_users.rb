class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :designation
      t.string :crypted_password
      t.string :mail_id
      t.string :balance,:default =>0
      t.string :server_user_name
      t.string :server_password
      t.string :password_salt
      t.string :persistence_token
      t.timestamps
    end
   create_table :roles do |t|
      t.column :name, :string
    end

    # generate the join table
    create_table :roles_users, :id => false do |t|
      t.column :role_id, :integer
      t.column :user_id, :integer
    end
    
    

    # Create admin role and user
    user_role = Role.create(:name => 'user')
    admin_role = Role.create(:name => 'admin') 
    admin = User.create do |u|
      u.name ='admin'
      u.username = 'admin'
      u.password = u.password_confirmation = 'admin'
      u.mail_id ='admin@gmail.com'
      u.designation = 'Software engineer'
     end
      admin.roles<< admin_role
   end
    
  def self.down
    drop_table :users
  end
end

