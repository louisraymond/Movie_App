class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :movie, null: false, foreign_key: true
      t.string :reviewer_name
      t.integer :stars
      t.text :review_text  # Add this line to include the review content

      t.timestamps
    end
  end
end