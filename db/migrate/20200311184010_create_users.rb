class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :avatar_url
      t.string :email
      t.boolean :notification

      t.timestamps
    end
  end
end
