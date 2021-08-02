class FieldsController < ActionController::Base
  def index
    render json: FieldsService.instance.fetch_fields
  end

  def updated_humus_balance
    fieldId = request.params[:fieldId]
    cropVal = request.params[:cropVal]
    cropYear = request.params[:cropYear]
    render json: FieldsService.instance.updated_humus_balance(fieldId,cropVal,cropYear)
  end
end
