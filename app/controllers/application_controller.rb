class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  def name_search
    !params[:min_price] && !params[:max_price]
  end

  def bad_params
    !params[:name] || params[:name] == ''
  end

  def find_object(object)
    object.find(params[:id])
  end

  def paginate(object)
    per_page = params.fetch(:per_page, 20)
    if params[:page].to_i > 0
      page =  per_page * (params.fetch(:page, 1).to_i - 1)
    else
      page = 0
    end
    object.limit(per_page).offset(page)
  end
end
