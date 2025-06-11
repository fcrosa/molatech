# script/generate_yearly_report.rb
require 'json'
require 'fileutils'
require_relative '../config/environment'

report = ReportService.generate_yearly_report

output_dir = File.join(__dir__, 'reports')
FileUtils.mkdir_p(output_dir)

timestamp = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
file_name = "report_#{timestamp}.json"
file_path = File.join(output_dir, file_name)

File.open(file_path, 'w') do |file|
  file.write(JSON.pretty_generate(report))
end

puts "Report stored in: #{file_path}"
