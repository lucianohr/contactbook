Dir.entries("#{Rails.root}/lib/jasperreports").each do |lib|
  require "jasperreports/#{lib}" if lib =~ /\.jar$/
end

require 'java'

java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::JRMapCollectionDataSource
# java_import Java::net::sf::jasperreports::engine::JREmptyDataSource;

class JasperReport
  DIR = "#{Rails.root}/app/reports"

  def initialize(report, dataset, params = nil)
    @model = report
    @dataset = dataset
    @report_params = params
  end

  def to_pdf
    # stmt = @conn.create_statement
    dataSource = JRMapCollectionDataSource.new()
    report_source = "#{DIR}/#{@model}.jasper"
    raise ArgumentError, "#@model does not exist." unless File.exist?(report_source)

    params = {CONTACT_NAME: 'fulado de tal'}
    params.merge!(@report_params) if @report_params.present?

    fill = JasperFillManager.fill_report(report_source, params, dataSource)
    pdf = JasperExportManager.export_report_to_pdf(fill)

    return pdf
  end
end