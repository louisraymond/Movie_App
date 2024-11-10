class MoviesController < ApplicationController
  class MoviesController < ApplicationController
    def index
      @movies = Movie.includes(:director, :actors, :filming_locations, :reviews)
  
      if params[:actor].present?
        @movies = @movies.joins(:actors).where('actors.name ILIKE ?', "%#{params[:actor]}%")
      end
  
      # Existing sorting functionality will be handled here later
    end
  end
  

end
