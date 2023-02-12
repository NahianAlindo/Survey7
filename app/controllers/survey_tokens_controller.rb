class SurveyTokensController < ApplicationController
  before_action :set_survey_token, only: %i[ show edit update destroy ]
  before_action :index_breadcrumb, only: %i[index new edit show]
  before_action :entry_breadcrumb, only: %i[edit show]
  # GET /survey_tokens or /survey_tokens.json
  def index
    @survey_tokens = SurveyToken.all
  end

  # GET /survey_tokens/1 or /survey_tokens/1.json
  def show
  end

  # GET /survey_tokens/new
  def new
    @survey_token = SurveyToken.new
    add_breadcrumb "New Survey Token"
  end

  # GET /survey_tokens/1/edit
  def edit
  end

  # POST /survey_tokens or /survey_tokens.json
  def create
    @survey_token = SurveyToken.new(survey_token_params)
    if @survey_token.save
      respond_to do |format|
        format.html { redirect_to survey_token_path, notice: "Quote was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @survey_token.update_attributes(survey_token_params)
      redirect_to survey_tokens_path,
                  notice: 'Survey token is successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    begin
      if @survey_token.destroy
        redirect_to survey_tokens_path,
                    notice: 'Survey token is successfully deleted.'
      end
    rescue StandardError => e
      redirect_back fallback_location: root_path,
                    flash: { error: 'controllers roles operation could not be completed.' }
    end
  end

  def show
    if @survey_token.Individual_Survey?
      @surveys = @survey_token.surveys.includes([:survey_project])
    else
      @surveys = Survey.includes([:survey_project]).where(survey_project_id: @survey_token.survey_projects.pluck(:id))
    end
  end


  def index_breadcrumb
    add_breadcrumb 'controllers.survey_tokens.survey_tokens', survey_tokens_path
  end

  def entry_breadcrumb
    add_breadcrumb @survey_token.token
  end

  private

  def survey_token_params
    params.require(:survey_token).permit(
      :token, :token_type, :start_date, :end_date, :active
    )
  end

  def set_survey_token
    begin
      @survey_token = SurveyToken.find(params[:id])
    rescue StandardError => e
      redirect_back fallback_location: survey_tokens_path,
                    flash: { error: invalid_id_error_message(e) }
    end
  end
end
