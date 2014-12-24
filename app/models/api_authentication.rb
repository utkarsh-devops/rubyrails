class ApiAuthentication

  def self.is_response_authenticated? params
    return [false, 'Signed key missing'] if params["signed_key"].blank?
    #Rails.logger.info("============PARAMS BEFORE============#{params.inspect}")
    parameter_data = params.reject{|key,value| ["action","signed_key","controller","format","photos", "auth_token"].include?(key)}
    #Rails.logger.info("============Actual PARAMS DATA============#{parameter_data.inspect}")
    hdata =  parameter_data.sort.collect{|i| i.last}.join("")
    #Rails.logger.info("============Hdata DATA============#{hdata.inspect}")
    #Rails.logger.info("============AFTER============#{parameter_data.sort.collect{|i| i.first}.inspect}============#{parameter_data.inspect}")
    digest_sig = OpenSSL::HMAC.hexdigest("sha1", "CHOC6186", hdata)
    #Rails.logger.info("======GENERATED KEY, RECEIVED KEY=====#{digest_sig}, #{params[:signed_key].to_s}")
    if params[:signed_key].to_s == digest_sig
      return [true]
    else
      Rails.logger.error "Invalid Secret key: #{params[:signed_key].to_s}"
      return [false, "Invalid Secret key: #{params[:signed_key].to_s}"]
    end
  end

end