class CreateFilmingLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :filming_locations do |t|
      t.string :location
      t.string :country

      t.timestamps
    end
  end
end
