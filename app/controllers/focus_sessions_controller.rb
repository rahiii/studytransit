class FocusSessionsController < ApplicationController
  def new
    @spaces = Space.includes(:library)
                   .references(:library)
                   .order("libraries.name ASC, spaces.name ASC")
  end
end
