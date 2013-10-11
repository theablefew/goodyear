# Goodyear

Adds ActiveRecord-like query interface to Tire.

## Installation

Add this line to your application's Gemfile:

    gem 'goodyear'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install goodyear

## Usage

### Query Builder

#### where()

```ruby
SomeModel.where( published: true, topic: "goats").first()
```

#### sort()

Orders results by field

```ruby
SomeModel.where( published: true, name: "Candy").sort(:score, :desc).first()
```

#### fields()

Specify fields to include in results

```ruby
SomeModel.where( published: true, name: "Candy").fields(:published, :name, :score).first()
```

#### first()

Sets size to 1 and fetches the results. Returns `SomeModel`

```ruby
SomeModel.where( published: true, name: "Candy").first()
```

#### fetch()

Exectues the query and returns `TireCollection`

```ruby
SomeModel.where( published: true).size(100).sort(:score, :desc).fetch()
```

### Scopes

Add chainable scopes just like you do in ActiveRecord. 

```ruby
class SomeModel < Tire
...
  scope :published, -> { where published: true }
end
```

### Facets

Coming soon.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
