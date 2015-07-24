class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :username
      t.string :bio
      t.string :email
      t.string :password_hash # this will be hashed, please don't get mad
    end
  end

  def down
    drop_table :users
  end  
end