module ApplicationHelper
  def number_to_phone_formater(num)
    num = num.to_s
    num_length = num.length
    if num_length <=3
      num
    elsif num_length <= 6
      num.unpack("A3A3").join("-")
    else
      num.unpack("A3A3A9").join("-")
    end
  end
end
