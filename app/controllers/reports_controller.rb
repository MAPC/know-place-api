class ReportsController < ApplicationController
  def index
    @reports = Report.all
    json = JSONAPI::Serializer.serialize(
      @reports, include: includes, is_collection: true
    )
    json[:links] = paginate @reports
    render json: json
  end

  def show
    @report = Report.find params[:id]
    json = JSONAPI::Serializer.serialize(
      @report, include: includes, is_collection: false
    )
    render json: json
  end
end
