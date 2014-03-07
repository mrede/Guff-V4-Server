class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :ip
      t.string :message
      t.string :accuracy
      t.float :latitude
      t.float :longitude
      t.string :device_id

      t.timestamps
    end
  end
end
