class CreateTestedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :tested_urls do |t|
      t.string :url

      t.float :ttfb
      t.float :tti
      t.float :ttfp
      t.float :speed_index

      t.boolean :passed, null: false, default: false

      t.timestamps

      t.index :url
      t.index :created_at
    end
  end
end
