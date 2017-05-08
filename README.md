# Pragma::Decorator

[![Build Status](https://img.shields.io/travis/pragmarb/pragma-decorator.svg?maxAge=3600&style=flat-square)](https://travis-ci.org/pragmarb/pragma-decorator)
[![Dependency Status](https://img.shields.io/gemnasium/pragmarb/pragma-decorator.svg?maxAge=3600&style=flat-square)](https://gemnasium.com/github.com/pragmarb/pragma-decorator)
[![Code Climate](https://img.shields.io/codeclimate/github/pragmarb/pragma-decorator.svg?maxAge=3600&style=flat-square)](https://codeclimate.com/github/pragmarb/pragma-decorator)
[![Coveralls](https://img.shields.io/coveralls/pragmarb/pragma-decorator.svg?maxAge=3600&style=flat-square)](https://coveralls.io/github/pragmarb/pragma-decorator)

Decorators are a way to easily convert your API resources to JSON with minimum hassle.

They are built on top of [ROAR](https://github.com/apotonick/roar). We provide some useful helpers
for rendering collections, expanding associations and much more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-decorator'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-decorator
```

## Usage

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

### Object Types

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

### Timestamps

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

### Associations

`Pragma::Decorator::Association` allows you to define associations in your decorator (currently,
only `belongs_to`/`has_one` associations are supported):

```ruby
module API
  module V1
    module Invoice
      module Decorator
        class Resource < Pragma::Decorator::Base
          feature Pragma::Decorator::Association

          belongs_to :customer
        end
      end
    end
  end
end
```

Rendering an invoice will now create the following representation:

```json
{
  "customer": 19
}
```

You can pass `expand[]=customer` as a request parameter and have the `customer` property expanded 
into a full object!

```json
{
  "customer": {
    "id": 19,
    "...": "..."
  }
}
```

This also works for nested associations. For instance, if the customer has a `company` association
marked as expandable, you can pass `expand[]=customer&expand[]=customer.company` to get that
association expanded too.

Note that you will have to pass the associations to expand as a user option when rendering:

```ruby
decorator = API::V1::Invoice::Decorator::Resource.new(invoice)
decorator.to_json(user_options: {
  expand: ['customer', 'customer.company', 'customer.company.contact']
})
```

Needless to say, this is done automatically for you when you use all components together through
the [pragma](https://github.com/pragmarb/pragma) gem! :)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-decorator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
