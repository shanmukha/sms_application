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
      t.integer:parent_id
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
    super_admin_role = Role.create(:name => 'super_admin')
    admin_role = Role.create(:name => 'admin') 
    teacher_role = Role.create(:name =>'teacher')
    super_admin = User.create do |u|
      u.name ='super_admin'
      u.username = 'super_admin'
      u.password = u.password_confirmation = 'password'
      u.mail_id ='super_admin@gmail.com'
      u.parent_id = 1
      u.designation = 'Software engineer'
     end
      super_admin.roles<< super_admin_role
      super_admin.roles<< admin_role
   end
    
  def self.down
    drop_table :users
  end
end

