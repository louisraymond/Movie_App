class MoviesController < ApplicationController
  def index
    @movies = Movie.includes(:director, :actors, :filming_locations, :reviews)

    if params[:actor].present?
      @movies = @movies.search_by_actor(params[:actor])
    end

    case params[:sort]
    when 'stars_asc'
      @movies = @movies.sort_by_average_stars_asc
    when 'stars_desc'
      @movies = @movies.sort_by_average_stars_desc
    else
      @movies = @movies.order(created_at: :desc)
    end
  end
end
