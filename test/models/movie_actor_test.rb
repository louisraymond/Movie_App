# test/models/movie_actor_test.rb

require 'test_helper'

class MovieActorTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    movie = Movie.create(
      title: "Inception",
      description: "A mind-bending thriller",
      year: 2010
    )
    actor = Actor.create(name: "Leonardo Di Caprio")
    movie_actor = MovieActor.new(movie: movie, actor: actor)
    assert movie_actor.valid?
  end

  test "should be invalid without a movie" do
    actor = Actor.create(name: "Leonardo Di Caprio")
    movie_actor = MovieActor.new(actor: actor)
    assert_not movie_actor.valid?
    assert_includes movie_actor.errors[:movie], "must exist"
  end

  test "should be invalid without an actor" do
    movie = Movie.create(
      title: "Inception",
      description: "A mind-bending thriller",
      year: 2010
    )
    movie_actor = MovieActor.new(movie: movie)
    assert_not movie_actor.valid?
    assert_includes movie_actor.errors[:actor], "must exist"
  end

  test "should belong to movie" do
    movie_actor = MovieActor.new
    assert_respond_to movie_actor, :movie
  end

  test "should belong to actor" do
    movie_actor = MovieActor.new
    assert_respond_to movie_actor, :actor
  end
end