module ErrorHandling

  def merchant_404
    error = ErrorMessage.new("No merchant(s) found", "NOT FOUND", 404)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def item_404
    error = ErrorMessage.new("No item(s) found", "NOT FOUND", 404)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def bad_request_400
    error = ErrorMessage.new("Bad Request - Invalid URL", "BAD REQUEST", 400)
    render json: ErrorSerializer.new(error).serialized_json, status: 400
  end
end
