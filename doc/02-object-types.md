# Object types

It is recommended that decorators expose the type of the decorated object. You can achieve this
with the `Type` mixin:

```ruby
module API
  module V1
    module User
      module Decorator
        class Resource < Pragma::Decorator::Base
          feature Pragma::Decorator::Type
        end
      end
    end
  end
end
```

This would result in the following representation:

```json
{
  "type": "user",
  "...": "...""
}
```

You can also set a custom type name (just make sure to use it consistently!):

```ruby
module API
  module V1
    module User
      module Decorator
        class Resource < Pragma::Decorator::Base
          def type
            :custom_type
          end
        end
      end
    end
  end
end
```

Note: `array` is already overridden with the more language-agnostic `list`.
