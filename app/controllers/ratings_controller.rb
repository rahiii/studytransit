class RatingsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def create
    space = Space.find(params.require(:space_id))
    rating_value = params.require(:value).to_i

    rating = space.ratings.build(value: rating_value)

    if rating.save
      render json: {
        status: "ok",
        rating_id: rating.id,
        average_rating_last_hour: space.average_rating_last_hour,
        created_at: rating.created_at
      }, status: :created
    else
      render json: { status: "error", errors: rating.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", errors: ["Space not found"] }, status: :not_found
  rescue ActionController::ParameterMissing => e
    render json: { status: "error", errors: [e.message] }, status: :unprocessable_entity
  end
end

