# frozen_string_literal: true

require 'roar'
require 'adaptor'

require 'pragma/decorator/version'

require 'pragma/decorator/base'

require 'pragma/decorator/association'
require 'pragma/decorator/association/reflection'
require 'pragma/decorator/association/bond'
require 'pragma/decorator/association/adapter/base'
require 'pragma/decorator/association/adapter/active_record'
require 'pragma/decorator/association/adapter/poro'
require 'pragma/decorator/association/adapter'
require 'pragma/decorator/association/errors'

require 'pragma/decorator/timestamp'

require 'pragma/decorator/type'

require 'pragma/decorator/collection'

require 'pragma/decorator/pagination'

require 'pragma/decorator/pagination/adapter/base'
require 'pragma/decorator/pagination/adapter/kaminari'
require 'pragma/decorator/pagination/adapter/will_paginate'
require 'pragma/decorator/pagination/adapter'

module Pragma
  # Represent your API resources in JSON with minimum hassle.
  module Decorator
  end
end
