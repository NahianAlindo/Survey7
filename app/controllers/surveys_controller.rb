class SurveysController < ApplicationController
  before_action :set_survey_project
  before_action :set_survey, only: %i[ show edit update destroy ]

  # GET /surveys or /surveys.json
  def index
    @pagy, @surveys = pagy(@survey_project.surveys.reorder(sort_column => sort_direction), items: params.fetch(:count, 5))
  end

  def sort_column
    %w{ title code }.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end

  # GET /surveys/1 or /surveys/1.json
  def show
  end

  # GET /surveys/new
  def new
    @survey = @survey_project.surveys.build
  end

  # GET /surveys/1/edit
  def edit
  end

  # POST /surveys or /surveys.json
  def create
    @survey = @survey_project.surveys.new(survey_params)

    if @survey.save
      flash.now[:notice] = "Survey was successfully created."
      render turbo_stream: [
        turbo_stream.prepend('surveys', @surveys),
        turbo_stream.replace(
          'form_survey',
          partial: 'form',
          locals: { survey: Survey.new }
        ),
        turbo_stream.replace('notice', partial: 'layouts/flash')
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /surveys/1 or /surveys/1.json
  def update
    if @survey.update(survey_params)
      flash.now[:notice] = 'Survey was successfully updated.'
      render turbo_stream: [
        turbo_stream.replace(@survey, @survey),
        turbo_stream.replace('notice', partial: 'layouts/flash')
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /surveys/1 or /surveys/1.json
  def destroy
    @survey.destroy

    flash.now[:notice] = 'Survey was successfully destroyed.'
    render turbo_stream: [
      turbo_stream.remove(@survey),
      turbo_stream.replace('notice', parital: 'layouts/flash')
    ]
  end


  private
  def set_survey_project
    @survey_project = SurveyProject.find(params[:survey_project_id])
  end

  def set_survey
    @survey = Survey.find(params[:id])
  end

  def survey_params
    params.require(:survey).permit(:title, :code, :title_bn, :survey_project_id, :survey_token_id)
  end
end
