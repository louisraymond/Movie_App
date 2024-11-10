class Movie < ApplicationRecord
  belongs_to :director
  has_many :movie_actors
  has_many :actors, through: :movie_actors
  has_many :movie_filming_locations
  has_many :filming_locations, through: :movie_filming_locations
  has_many :reviews

  validates :title, presence: true
end