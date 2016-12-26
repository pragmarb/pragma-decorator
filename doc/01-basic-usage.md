# Basic usage

Creating a decorator is as simple as inheriting from `Pragma::Decorator::Base`:

```ruby
module API
  module V1
    module User
      module Decorator
        class Resource < Pragma::Decorator::Base
          property :id
          property :email
          property :full_name
        end
      end
    end
  end
end
```

Just instantiate the decorator by passing it an object to decorate, then call `#to_hash` or
`#to_json`:

```ruby
decorator = API::V1::User::Decorator::Resource.new(user)
decorator.to_json
```

This will produce the following JSON:

```json
{
  "id": 1,
  "email": "jdoe@example.com",
  "full_name": "John Doe"
}
```

Since Pragma::Decorator is built on top of [ROAR](https://github.com/apotonick/roar) (which, in
turn, is built on top of [Representable](https://github.com/apotonick/representable)), you should
consult their documentation for the basic usage of decorators; the rest of this section only covers
the features provided specifically by Pragma::Decorator.
