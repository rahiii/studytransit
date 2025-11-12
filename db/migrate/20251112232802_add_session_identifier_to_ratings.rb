class AddSessionIdentifierToRatings < ActiveRecord::Migration[8.0]
  def change
    add_column :ratings, :session_identifier, :string
    add_index :ratings, [ :space_id, :session_identifier ], name: "index_ratings_on_space_id_and_session_identifier"
  end
end
