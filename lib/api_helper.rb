module ApiHelper
  # Checks if required parameters are present in given params hash
  def params_present? required_params, params
    errors = []
    required_params.each {|key, values| errors << "#{key} information missing" if params[key].blank?}
    return false, errors.join(" And ") unless errors.empty?
    required_params.each do |key, values|
      values.each {|val| errors << "#{key}: #{val} missing" if params[key][val].blank?}
    end
    return false, errors.join(" And ") unless errors.empty?
    true
  end

  # Parses JSON, if failed/crashed during parsing returns {}
  def json_parse params
    parsed_parameters = {}
    begin
      parsed_parameters = JSON.parse(params, symbolize_names: true)
    rescue Exception => e
      ErrorLogger.log("\n\n #{Time.now}\nError While Parsing Params: #{params}")
    end
    parsed_parameters
  end
end