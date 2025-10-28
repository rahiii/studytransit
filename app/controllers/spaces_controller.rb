class SpacesController < ApplicationController
  before_action :set_space, only: %i[ show edit update destroy ]

  # GET /spaces or /spaces.json
  def index
    @spaces = Space.all
  end

  # GET /spaces/1 or /spaces/1.json
  def show
  end

  # GET /spaces/new
  def new
    @space = Space.new
  end

  # GET /spaces/1/edit
  def edit
  end

  # POST /spaces or /spaces.json
  def create
    @space = Space.new(space_params)

    respond_to do |format|
      if @space.save
        format.html { redirect_to @space, notice: "Space was successfully created." }
        format.json { render :show, status: :created, location: @space }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1 or /spaces/1.json
  # TODO: Implement capacity update functionality
  def update
    respond_to do |format|
      # Placeholder - template only
      format.html { redirect_to library_path(@space.library), notice: "Template only - implement update functionality", status: :see_other }
    end
  end

  # DELETE /spaces/1 or /spaces/1.json
  def destroy
    @space.destroy!

    respond_to do |format|
      format.html { redirect_to spaces_path, notice: "Space was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = Space.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def space_params
      params.expect(space: [ :name, :capacity, :library_id ])
    end
end
