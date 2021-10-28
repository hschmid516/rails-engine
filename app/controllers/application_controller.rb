class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def name_search
    !params[:min_price] && !params[:max_price]
  end

  def bad_params
    !params[:name] || params[:name] == ''
  end
end
