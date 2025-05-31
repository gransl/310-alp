module Util
  def float?(str)
    Float(str)
    true
  rescue ArgumentError
    false
  end
end