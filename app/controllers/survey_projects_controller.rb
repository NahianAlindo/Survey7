class SurveyProjectsController < ApplicationController
  before_action :set_survey_project, only: %i[ show edit update destroy ]

  # GET /survey_projects or /survey_projects.json
  def index
    @survey_projects = SurveyProject.all
  end

  # GET /survey_projects/1 or /survey_projects/1.json
  def show
  end

  # GET /survey_projects/new
  def new
    @survey_project = SurveyProject.new
  end

  # GET /survey_projects/1/edit
  def edit
  end

  # POST /survey_projects or /survey_projects.json
  def create
    @survey_project = SurveyProject.new(survey_project_params)

    respond_to do |format|
      if @survey_project.save
        format.html { redirect_to survey_project_url(@survey_project), notice: "Survey project was successfully created." }
        format.json { render :show, status: :created, location: @survey_project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @survey_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /survey_projects/1 or /survey_projects/1.json
  def update
    respond_to do |format|
      if @survey_project.update(survey_project_params)
        format.html { redirect_to survey_project_url(@survey_project), notice: "Survey project was successfully updated." }
        format.json { render :show, status: :ok, location: @survey_project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @survey_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /survey_projects/1 or /survey_projects/1.json
  def destroy
    @survey_project.destroy

    respond_to do |format|
      format.html { redirect_to survey_projects_url, notice: "Survey project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_project
      @survey_project = SurveyProject.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_project_params
      params.fetch(:survey_project, {})
    end
end
