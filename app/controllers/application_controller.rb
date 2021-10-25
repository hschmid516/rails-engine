class ApplicationController < ActionController::API
  def no_object_error(id)
    render json: {
        message: "your query could not be completed",
        errors: ["no object found with id: #{id}"],
      }, status: 404
  end
end
