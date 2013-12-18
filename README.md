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


```ruby
class SomeModel < Tire
    include Goodyear::ElasticQuery
end
```

#### Better persistence via dynamic attributes. 

Including `Goodyear::Persistence` in your model means you don't have to worry about defining everything with Tire's `#property` method. 

```ruby
class SomeModel < Tire
    include Goodyear::ElasticQuery
    include Goodyear::Persistence
end
```


### Query Builder

#### where()

```ruby
SomeModel.where( published: true, topic: "goats")
```

#### or()

```ruby
SomeModel.where(status: 'inactive').or.where( retired: true)
```

#### sort()

Orders results by field

```ruby
SomeModel.where( published: true, name: "Candy").sort(:score, :desc)
```

#### fields()

Specify fields to include in results

```ruby
SomeModel.where( published: true, name: "Candy").fields(:published, :name, :score)
```

#### first()

Sets size to 1 and fetches the first result. Returns `SomeModel`

```ruby
SomeModel.where( published: true, name: "Candy").first
```

#### last()

Returns the last result

```ruby
SomeModel.where( published: true).last
```


#### fetch()

Exectues the query and returns `TireCollection`

```ruby
SomeModel.where( published: true).size(100).sort(:score, :desc)
```

### Scopes

Add chainable scopes just like you do in ActiveRecord. 

```ruby
class SomeModel
  include Tire::Model::Persistence
  include ActiveRecord::Callbacks
  include Goodyear::ElasticQuery
  include Goodyear::Persistence
...
  scope :published, -> { where published: true }
end
```

### Facets

```ruby
SomeModel.where(created_at: 1.year.ago).facet('top_users') { terms 'users', size: 50 }
```

```ruby
SomeModel.facet('stats') { date :created_at, interval: "1m", pre_zone_adjust_large_interval: true, time_zone: "-0500"}
```

### Query Filters

```ruby
SomeModel.where(width: 10).filter(:range,  {height: { gte: 10, lte: 200} })
```

There's also a convenience method for Exists filters. 

```ruby
SomeModel.has_field?(:width).where(width:10)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
