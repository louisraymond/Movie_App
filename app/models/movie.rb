class Movie < ApplicationRecord
  belongs_to :director
  has_many :movie_actors
  has_many :actors, through: :movie_actors
  has_many :movie_filming_locations
  has_many :filming_locations, through: :movie_filming_locations
  has_many :reviews

  validates :title, presence: true
  validates :year, presence: true

  scope :search_by_actor, ->(actor_name) {
    joins(:actors).where('actors.name LIKE ?', "%#{actor_name}%")
  }

  scope :sort_by_average_stars_asc, -> {
    left_outer_joins(:reviews)
      .select('movies.*, AVG(reviews.stars) AS average_stars')
      .group('movies.id')
      .order('average_stars ASC')
  }

  scope :sort_by_average_stars_desc, -> {
    left_outer_joins(:reviews)
      .select('movies.*, AVG(reviews.stars) AS average_stars')
      .group('movies.id')
      .order('average_stars DESC')
  }

  def average_stars
    self[:average_stars]
  end
end
