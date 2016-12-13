class BatchFilesController < ApplicationController

  def index
    @batch_files = BatchFile.with_processor.page(params[:page]).per(3)
  end

  def new
    @processors = BatchFileProcessor.all
    @user = User.active_users
  end

  def create
    begin
      @batch_file = BatchFile.create!(batch_file_attrs)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      redirect_to :back
    end
    redirect_to batch_file_path(@batch_file)
  end

  def show
    @batch_file = BatchFile.find_by_id(params[:id])
    @headers = @batch_file.batch_file_processor.csv_header_row.split(',')
    @statuses = @batch_file.statuses
    @all_statuses = (@statuses + ['all']).reverse
    @batch_file_line = lines
  end


  def run
    BatchFile.find_by_id(batch_file_id).process!
  end

  def process_file_lines
    BatchFile.find_by_id(batch_file_id).process!
    redirect_to :back
  end

  def validate_file_lines
    BatchFile.find_by_id(batch_file_id).validate!
    redirect_to :back
  end

  private

  def batch_file_attrs
    {
      processor_type_id: processor_type_id,
      csv_file_name: csv_file_name,
      csv_content_type: csv_content_type,
      contents: csv_content,
      description: description,
      created_by_id: user_id
    }
  end

  def processor_type_id
    params.require(:batch_file).require(:processor_id).to_i
  end

  def description
    params.require(:batch_file).require(:description)
  end

  def user_id
    params.require(:batch_file).require(:user_id)
  end

  def file_details
    params.require(:batch_file).require(:csv)
  end

  def batch_file_id
    params.require(:batch_files).require(:batch_file_id) || params.require(:batch_file_id)
  end

  def csv_content_type
    file_details.content_type
  end

  def csv_file_name
    file_details.original_filename
  end

  def csv_content
    CSV.parse(file_details.tempfile)
  end

  def lines
    BatchFileLine.lines_with_headers(params[:id]).page(page_number).per(per_page)
  end

  def page_number
    params[:page] || 1
  end

  def per_page
     params[:per_page] || 10
  end

  def date_range
    params.values_at(:date_from, :date_to).map(&:to_date)
  end
end
