module Pagination

  def number_per_page
    params.fetch(:per_page, 20).to_i
  end

  def page_number
    if params[:page] && params[:page].to_i > 0
      params[:page].to_i - 1
    else
      0
    end
  end
  
end
