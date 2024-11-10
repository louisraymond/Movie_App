require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    movie = Movie.create(title: "Inception", description: "...", year: 2010)
    review = Review.new(movie: movie, reviewer_name: "John Doe", stars: 5)
    assert review.valid?
  end

  test "should be invalid without a movie" do
    review = Review.new(reviewer_name: "John Doe", stars: 5)
    assert_not review.valid?
    assert_includes review.errors[:movie], "must exist"
  end

  test "should belong to a movie" do
    review = Review.new
    assert_respond_to review, :movie
  end
end