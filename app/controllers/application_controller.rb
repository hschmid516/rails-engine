class ApplicationController < ActionController::API
  def no_merchant_error
    render json: {
        message: "your query could not be completed",
        errors: ["no merchant found with id: #{params[:merchant_id]}"],
      }, status: 404
  end
end
