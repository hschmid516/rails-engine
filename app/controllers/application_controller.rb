class ApplicationController < ActionController::API
  def no_object_error(id)
    render json: {
        message: "your query could not be completed",
        errors: ["no object found with id: #{id}"],
      }, status: 404
  end

  def no_params_error
    render json: {
        message: "merchant could not be found",
        error: "query params must be present and not empty",
      }, status: 400
  end
end
