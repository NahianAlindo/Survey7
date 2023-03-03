class SurveyProjectsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_survey_project, only: %i[ show edit update destroy ]

  # GET /survey_projects or /survey_projects.json
  def index
    filtered = SurveyProject.where("title LIKE ?", "%#{params[:filter]}%")
    @pagy, @survey_projects = pagy(filtered.all.reorder(sort_column => sort_direction), items: params.fetch(:count, 5))
  end


  def sort_column
    %w{ title active private code }.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
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
    if @survey_project.save
      flash.now[:notice] = "Survey Project was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("survey_projects", @survey_project),
        turbo_stream.replace(
          "form_survey_project",
          partial: "form",
          locals: { survey_project: SurveyProject.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /survey_projects/1 or /survey_projects/1.json
  def update
    if @survey_project.update(survey_project_params)
      flash.now[:notice] = "Survey Project was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@survey_project, @survey_project),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /survey_projects/1 or /survey_projects/1.json
  def destroy
    @survey_project.destroy
    flash.now[:notice] = "Survey Project was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@survey_project),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private
  def set_survey_project
    @survey_project = SurveyProject.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def survey_project_params
    params.require(:survey_project).permit(
      :active, :private, :title, :code, :title_bn
    )
  end
end
