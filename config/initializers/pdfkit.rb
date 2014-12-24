#pdfkit.rb
PDFKit.configure do |config|
  if ["development"].include?(Rails.env)
    #only if your are working on 32bit machine
    config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf-i386').to_s
  else
    #if your site is hosted on heroku or any other hosting server which is 64bit
    config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf-amd64').to_s
  end
  config.default_options = {
      :encoding=>"UTF-8",
      :page_size=>"A4",
      :margin_top=>"0.25in",
      :margin_right=>"0.1in",
      :margin_bottom=>"0.25in",
      :margin_left=>"0.1in",
      :disable_smart_shrinking=> false
  }
end