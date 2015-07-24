class CreateTweets < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.integer :user_id
      t.string :content
      t.timestamps
    end
  end
  def down
    drop_table :tweets
  end
end
