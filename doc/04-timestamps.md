# Timestamps

[UNIX time](https://en.wikipedia.org/wiki/Unix_time) is your safest bet when rendering/parsing
timestamps in your API, as it doesn't require a timezone indicator (the timezone is always UTC).

You can use the `Timestamp` mixin for converting `Time` instances to UNIX times:

```ruby
module API
  module V1
    module User
      module Decorator
        class Resource < Pragma::Decorator::Base
          feature Pragma::Decorator::Timestamp

          timestamp :created_at
        end
      end
    end
  end
end
```

This will render a user like this:

```json
{
  "type": "user",
  "created_at": 1480287994
}
```

The `#timestamp` method supports all the options supported by `#property` (except for `:as`).
