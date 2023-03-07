class ApplicationController < ActionController::Base
  include Pagy::Backend
  def invalid_id_error_message(e)
    "#{"Invalid"} #{e}"
  end
end
