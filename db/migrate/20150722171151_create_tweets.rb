class CreateTweets < ActiveRecord::Migration
  def up
    create_table :tweets do |t|
      t.string :username
      t.string :content
      t.timestamps
    end
  end
  def down
    drop_table :tweets
  end
end
