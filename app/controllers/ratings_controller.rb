class RatingsController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def create
    space = Space.find(params.require(:space_id))
    rating_value = params.require(:value).to_i
    session_id = get_or_create_session_identifier

    # Check if user has rated this space in the last hour
    one_hour_ago = 1.hour.ago
    existing_rating = space.ratings
                          .where(session_identifier: session_id)
                          .where("created_at >= ?", one_hour_ago)
                          .order(created_at: :desc)
                          .first

    if existing_rating
      # Update existing rating if within the hour
      if existing_rating.update(value: rating_value)
        render json: {
          status: "ok",
          rating_id: existing_rating.id,
          action: "updated",
          average_rating_last_hour: space.average_rating_last_hour,
          created_at: existing_rating.created_at,
          updated_at: existing_rating.updated_at
        }, status: :ok
      else
        render json: { status: "error", errors: existing_rating.errors.full_messages }, status: :unprocessable_content
      end
    else
      # Create new rating if no rating in the last hour
      rating = space.ratings.build(value: rating_value, session_identifier: session_id)
      if rating.save
        render json: {
          status: "ok",
          rating_id: rating.id,
          action: "created",
          average_rating_last_hour: space.average_rating_last_hour,
          created_at: rating.created_at,
          updated_at: rating.updated_at
        }, status: :created
      else
        render json: { status: "error", errors: rating.errors.full_messages }, status: :unprocessable_content
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: "error", errors: [ "Space not found" ] }, status: :not_found
  rescue ActionController::ParameterMissing => e
    render json: { status: "error", errors: [ e.message ] }, status: :unprocessable_content
  end

  private

  def get_or_create_session_identifier
    # Try to use session ID first (for web requests with sessions)
    return "session_#{session.id}" if session.id.present?

    # For JSON API requests, use a cookie-based identifier
    # Generate a unique identifier and store it in a cookie
    cookie_name = "rating_session_id"
    session_id = cookies[cookie_name]

    unless session_id.present?
      # Generate a unique identifier (UUID-like)
      session_id = SecureRandom.uuid
      # Store in cookie (expires in 30 days)
      cookies[cookie_name] = {
        value: session_id,
        expires: 30.days.from_now,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }
    end

    "cookie_#{session_id}"
  end
end
