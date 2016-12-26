# Associations

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
  "customer": {
    "id": 19
  }
}
```

Not impressed? Just wait.

We also support association expansion through an interface similar to the one provided by the
[Stripe API](https://stripe.com/docs/api/curl#expanding_objects). You can define which associations
are expandable in the decorator:

```ruby
module API
  module V1
    module Invoice
      module Decorator
        class Resource < Pragma::Decorator::Base
          feature Pragma::Decorator::Association

          belongs_to :customer, expandable: true
        end
      end
    end
  end
end
```

You can now pass `expand[]=customer` as a request parameter and have the `customer` property
expanded into a full object!

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

In order for association expansion to work, you will have to pass the associations to expand to the
representer as a user option:

```ruby
decorator = API::V1::Invoice::Decorator::Resource.new(invoice)
decorator.to_json(user_options: {
  expand: ['customer', 'customer.company', 'customer.company.contact']
})
```

Here's a list of options accepted when defining an association:

Name | Type | Default | Meaning
---- | ---- | ------- | -------
`expandable` | Boolean | `false` | Whether this association is expandable by consumers. Attempting to expand a non-expandable association will raise a `UnexpandableError`.
`decorator` | Class | - | If provided, decorates the expanded object with this decorator. Otherwise, simply calls `#to_hash` on the object to get a representable hash.
`render_nil` | Boolean | `false` | Whether the property should be rendered at all when it is `nil`.
`exec_context` | Symbol | `:decorated` | Whether to call the getter on the decorator (`:decorator`) or the decorated object (`:decorated`).
