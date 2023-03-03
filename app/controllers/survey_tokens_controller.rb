class SurveyTokensController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_survey_token, only: %i[ show edit update destroy ]
  before_action :index_breadcrumb, only: %i[index new edit show]
  before_action :entry_breadcrumb, only: %i[edit show]
  # GET /survey_tokens or /survey_tokens.json
  def index
    filtered = SurveyToken.where("token LIKE ?", "%#{params[:filter]}%")
    @pagy, @survey_tokens = pagy(filtered.all.reorder(sort_column => sort_direction), items: params.fetch(:count, 5))

  end

  def sort_column
    %w{ token start_date end_date token_type active }.include?(params[:sort]) ? params[:sort] : "token"
  end

  def sort_direction
    %w{ asc desc }.include?(params[:direction]) ? params[:direction] : "asc"
  end
  # GET /survey_tokens/1 or /survey_tokens/1.json
  def show
  end

  # GET /survey_tokens/new
  def new
    @survey_token = SurveyToken.new
  end

  # GET /survey_tokens/1/edit
  def edit
  end

  # POST /survey_tokens or /survey_tokens.json
  def create
    @survey_token = SurveyToken.new(survey_token_params)

    if @survey_token.save
      flash.now[:notice] = "Survey Token was successfully created."
      render turbo_stream: [
        turbo_stream.prepend("survey_tokens", @survey_token),
        turbo_stream.replace(
          "form_survey_token",
          partial: "form",
          locals: { survey_token: SurveyToken.new }
        ),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @survey_token.update(survey_token_params)
      flash.now[:notice] = "Survey Token was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@survey_token, @survey_token),
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @survey_token.destroy
    flash.now[:notice] = "Survey Token was successfully destroyed."
    render turbo_stream: [
      turbo_stream.remove(@survey_token),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
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
    @survey_token = SurveyToken.find(params[:id])
  end
end
