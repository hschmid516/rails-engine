module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :not_found)
    end

    def bad_params_error
      render json: {
          message: "object could not be found",
          error: "query params must be present and not empty",
        }, status: 400
    end

    def search_error
      render json: {
          message: "items could not be found",
          error: "params cannot include name and max/min price",
        }, status: 400
    end
  end
end
