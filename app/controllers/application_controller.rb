class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  require 'jasper_report'

  def respond_to_report(name, filename, data, download = false, report_params = nil)
    @report = JasperReport.new(name, data, report_params) 
    disposition = (download.nil? || download == false) ? 'inline' : 'attachment'
    send_data @report.to_pdf, filename: filename, type: 'application/pdf', disposition: disposition
  end

end
