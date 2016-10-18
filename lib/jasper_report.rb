Dir.entries("#{Rails.root}/lib/jasperreports").each do |lib|
  require "jasperreports/#{lib}" if lib =~ /\.jar$/
end

require 'java'

java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net::sf::jasperreports::engine::data::JRMapCollectionDataSource
java_import Java::net::sf::jasperreports::engine::JREmptyDataSource;

class JasperReport
  DIR = "#{Rails.root}/app/reports/"

  def initialize(report, dataset, params = nil)
    @model = report
    @dataset = dataset
    @report_params = params
  end

  def to_pdf
    if @dataset.present?
      data = java.util.ArrayList.new
      @dataset.each do |item|
        mapItem = java.util.HashMap.new
        
        # subtasks = java.util.ArrayList.new
        item.each do |k,v|
          # if k == :subtasks
          #   v.each do |sub_item|
          #     subItem = java.util.HashMap.new
          #     sub_item.each {|sub_k, sub_v| subItem.put(sub_k.to_s, sub_v.to_s)}
          #     subtasks.add(subItem)
          #   end
          #   mapItem.put('subtasks', subtasks)
          # else
          mapItem.put(k.to_s, v.to_s)
          # end
        end
        data.add(mapItem)
      end
      dataSource = JRMapCollectionDataSource.new(data)
    else
      dataSource = JREmptyDataSource.new()
    end
    report_source = "#{DIR}#{@model}.jasper"
    raise ArgumentError, "#@model does not exist." unless File.exist?(report_source)
    params = {
      CONTACT_NAME: 'fulado de tal', 
      LOGO: 'https://www.scopi.com.br/css/img/topMenu2/planejamento-estrategico-scopi.png',
      SUBREPORT_DIR: DIR
    }
    params.merge!(@report_params) if @report_params.present?
    parameters = java.util.HashMap.new
    params.each{|k,v| parameters.put(k.to_s, v.to_s)}
    fill = JasperFillManager.fill_report(report_source, parameters, dataSource)
    pdf = JasperExportManager.export_report_to_pdf(fill)

    return pdf
  end
end