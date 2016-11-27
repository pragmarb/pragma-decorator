require 'roar/decorator'
require 'roar/json'

module Pragma
  module Decorator
    class Base < Roar::Decorator
      feature Roar::JSON
    end
  end
end
