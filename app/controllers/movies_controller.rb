class MoviesController < ApplicationController
  def index
    @movies = Movie.includes(:director, :actors, :filming_locations, :reviews)

    if params[:actor].present?
      @movies = @movies.joins(:actors).where('actors.name LIKE ?', "%#{params[:actor]}%")
    end

  end
end
