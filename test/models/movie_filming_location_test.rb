require "test_helper"

class MovieFilmingLocationTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    movie = Movie.create(
      title: "Inception",
      description: "A mind-bending thriller",
      year: 2010
    )
    filming_location = FilmingLocation.create(
      location: "Los Angeles",
      country: "US"
    )
    movie_filming_location = MovieFilmingLocation.new(
      movie: movie,
      filming_location: filming_location
    )
    assert movie_filming_location.valid?
  end

  test "should be invalid without a movie" do
    filming_location = FilmingLocation.create(
      location: "Los Angeles",
      country: "US"
    )
    movie_filming_location = MovieFilmingLocation.new(filming_location: filming_location)
    assert_not movie_filming_location.valid?
    assert_includes movie_filming_location.errors[:movie], "must exist"
  end

  test "should be invalid without a filming_location" do
    movie = Movie.create(
      title: "Inception",
      description: "A mind-bending thriller",
      year: 2010
    )
    movie_filming_location = MovieFilmingLocation.new(movie: movie)
    assert_not movie_filming_location.valid?
    assert_includes movie_filming_location.errors[:filming_location], "must exist"
  end

  test "should belong to movie" do
    movie_filming_location = MovieFilmingLocation.new
    assert_respond_to movie_filming_location, :movie
  end

  test "should belong to filming_location" do
    movie_filming_location = MovieFilmingLocation.new
    assert_respond_to movie_filming_location, :filming_location
  end
end