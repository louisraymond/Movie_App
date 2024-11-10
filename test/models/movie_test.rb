require 'test_helper'

class MovieTest < ActiveSupport::TestCase

test "should be valid with valid attributes" do
    director = Director.create(name: "Christopher Nolan")
    actor = Actor.create(name: "Leonardo DiCaprio")
    movie = Movie.new(
        title: "Inception",
        description: "A thief who steals corporate secrets...",
        year: 2010,
        director: director
    )
    movie.actors << actor
    assert movie.valid?
end

  test "should be invalid without a title" do
    movie = Movie.new
    assert_not movie.valid?
    assert_includes movie.errors[:title], "can't be blank"
  end

  test "should belong to a director" do
    movie = Movie.new
    assert_respond_to movie, :director
  end

  test "should have actors" do
    movie = Movie.new
    assert_respond_to movie, :actors
  end

  test "should have many filming locations" do
    movie = Movie.new
    assert_respond_to movie, :filming_locations
  end

  test "should have reviews" do
    movie = Movie.new
    assert_respond_to movie, :reviews
  end
end