class ApplicationController < ActionController::API
  include Pagy::Backend
  before_action :authenticate_user!
  respond_to :json
  
  def index
    render json: records({record_parse: as_json}), status: :ok
  end

  def create
    begin
      record = resource_model.new(resource_params)
      record.save!
      render json: { success: true, message: 'Successfully save record.' }
    rescue => e
      render json: { success: false, message: record.errors.full_message }
    end
  end
  
  
  def pagination_metadata(pagy)
    {
      current_page: pagy.page,
      next_page: pagy.next,
      prev_page: pagy.prev,
      total_pages: pagy.pages,
      total_count: pagy.count
    }
  end
  
  def records(opts = {})
    _pagy, _records = pagy(resource_model.all, **(opts[:pagination] || {}))
    convert_to_json = _records.as_json(opts[:record_parse] || {})
    {
      data: convert_to_json,
      pagination: pagination_metadata(_pagy),
      attributes: convert_to_json.first.keys,
      **(opts[:json] || {})
    }
  end

  def as_json
    {
      only: [:id, :name]
    }
  end

  def resource_model
    self.class.name.demodulize.sub('Controller', '').singularize.constantize
  end
end
