require 'rails_helper'

RSpec.describe "/ratings", type: :request do
  let!(:library) { Library.create!(name: "Test Library", location: "Test Location") }
  let!(:space) { Space.create!(name: "Test Space", library: library) }
  let(:session_identifier) { "test_session_123" }

  describe "POST /ratings" do
    context "with valid parameters" do
      it "creates a new rating" do
        expect {
          post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        }.to change(Rating, :count).by(1)
      end

      it "returns a successful response" do
        post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        expect(response).to have_http_status(:created)
      end

      it "returns the rating data" do
        post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        expect(response.parsed_body["status"]).to eq("ok")
        expect(response.parsed_body["rating_id"]).to be_present
        expect(response.parsed_body["action"]).to eq("created")
        expect(response.parsed_body["average_rating_last_hour"].to_f).to eq(5.0)
      end

      it "updates existing rating if same session rates again within an hour" do
        # Stub the session identifier to return the same value
        allow_any_instance_of(RatingsController).to receive(:get_or_create_session_identifier).and_return(session_identifier)

        # Manually create a rating 30 minutes ago with the session identifier
        initial_rating = Rating.create!(
          space: space,
          value: 4,
          session_identifier: session_identifier,
          created_at: 30.minutes.ago,
          updated_at: 30.minutes.ago
        )

        expect(space.ratings.count).to eq(1)
        expect(initial_rating.value).to eq(4)

        # Rate again within the hour - should update, not create
        expect {
          post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        }.not_to change(Rating, :count)

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body["action"]).to eq("updated")
        expect(initial_rating.reload.value).to eq(5)
        expect(space.ratings.count).to eq(1)
      end

      it "creates new rating if same session rates after an hour has passed" do
        # Stub the session identifier to return the same value
        allow_any_instance_of(RatingsController).to receive(:get_or_create_session_identifier).and_return(session_identifier)

        # Manually create a rating more than an hour ago
        old_rating = Rating.create!(
          space: space,
          value: 4,
          session_identifier: session_identifier,
          created_at: 2.hours.ago,
          updated_at: 2.hours.ago
        )

        expect(space.ratings.count).to eq(1)
        expect(old_rating.value).to eq(4)

        # Rate again after an hour - should create new rating
        expect {
          post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        }.to change(Rating, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.parsed_body["action"]).to eq("created")
        expect(space.ratings.count).to eq(2)
        expect(space.ratings.pluck(:value)).to match_array([ 4, 5 ])
      end

      it "allows different sessions to rate the same space independently" do
        # First session rates
        allow_any_instance_of(RatingsController).to receive(:get_or_create_session_identifier).and_return("session_1")
        post ratings_url, params: { space_id: space.id, value: 4 }, as: :json
        expect(response).to have_http_status(:created)

        # Second session rates (different identifier)
        allow_any_instance_of(RatingsController).to receive(:get_or_create_session_identifier).and_return("session_2")
        expect {
          post ratings_url, params: { space_id: space.id, value: 5 }, as: :json
        }.to change(Rating, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(space.ratings.count).to eq(2)
        expect(space.ratings.pluck(:value)).to match_array([ 4, 5 ])
      end
    end

    context "with invalid parameters" do
      it "does not create a rating without space_id" do
        expect {
          post ratings_url, params: { value: 5 }, as: :json
        }.to change(Rating, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not create a rating without value" do
        expect {
          post ratings_url, params: { space_id: space.id }, as: :json
        }.to change(Rating, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not create a rating with value less than 1" do
        expect {
          post ratings_url, params: { space_id: space.id, value: 0 }, as: :json
        }.to change(Rating, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "does not create a rating with value greater than 5" do
        expect {
          post ratings_url, params: { space_id: space.id, value: 6 }, as: :json
        }.to change(Rating, :count).by(0)
        expect(response).to have_http_status(:unprocessable_content)
      end

      it "returns 404 for non-existent space" do
        post ratings_url, params: { space_id: 99999, value: 5 }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
