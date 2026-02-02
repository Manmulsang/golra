# Golra

A filtering library for Rails.

Building an API? You'll eventually need a filter layer. Once `if params[:status]` branches start piling up in your controller, it's already too late.

Golra provides:
- **Automatic filtering** - Just pass params with `attribute__predicate` syntax
- **Extensible** - Add custom scope methods for complex logic
- **Explicit** - Only permitted attributes can be filtered, no magic

## Installation

```ruby
gem 'golra'
```

## Quick Start

```ruby
# app/golras/user_golra.rb
class UserGolra < Golra::Base
  permit :name, :email, :age, :status
end

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = UserGolra.apply(User.all, filter_params)
  end

  private

  def filter_params
    params.permit(:name__eq, :name__cont, :age__gteq, :status__in, sort: [])
  end
end
```

```
GET /users?name__cont=john&age__gteq=18&sort=created_at__desc
```

## Predicates

| Predicate | SQL |
|-----------|-----|
| `eq` | `=` |
| `not_eq` | `!=` |
| `cont` | `LIKE '%v%'` |
| `start_with` | `LIKE 'v%'` |
| `end_with` | `LIKE '%v'` |
| `gt` / `gteq` | `>` / `>=` |
| `lt` / `lteq` | `<` / `<=` |
| `in` / `not_in` | `IN` / `NOT IN` |
| `null` / `not_null` | `IS NULL` / `IS NOT NULL` |

## Sorting

```ruby
UserGolra.apply(User.all, { sort: "created_at__desc" })
UserGolra.apply(User.all, { sort: ["created_at__desc", "name__asc"] })
```

## Association Filtering

Use `::` separator to filter by associated models. Associations must be explicitly declared:

```ruby
class PostGolra < Golra::Base
  permit :title, :published
end

class UserGolra < Golra::Base
  permit :name, :email
  association :posts, PostGolra  # explicit declaration required
end

# "Users whose posts have titles containing 'Rails'"
UserGolra.apply(User.all, { "posts::title__cont" => "Rails" })
# => SELECT users.* FROM users
#    INNER JOIN posts ON posts.user_id = users.id
#    WHERE posts.title LIKE '%Rails%'
```

Permits are managed by each Golra class. If `PostGolra` doesn't `permit :title`, it raises an error.

## Custom Scope

Define a method with the same name as the params key:

```ruby
class UserGolra < Golra::Base
  permit :name, :email, :age

  # handles params[:search]
  def self.search(scope, value)
    scope.where("name LIKE :q OR email LIKE :q", q: "%#{value}%")
  end

  # handles params[:age_range]
  def self.age_range(scope, value)
    min, max = value
    scope.where(age: min..max)
  end

  # handles params[:has_posts]
  def self.has_posts(scope, value)
    value ? scope.joins(:posts).distinct : scope
  end
end

# Usage
UserGolra.apply(User.all, { search: "john" })
UserGolra.apply(User.all, { age_range: [18, 65] })
UserGolra.apply(User.all, { has_posts: true })
```

## Errors

Invalid filters always raise errors:

- `UnpermittedAttributeError` - attribute not permitted
- `InvalidFilterKeyError` - invalid filter key format
- `UnsupportedPredicateError` - predicate doesn't support the type
- `CastError` - type casting failed
- `InvalidSortError` - invalid sort format
- `AssociationNotFoundError` - association not declared

## Database Support

- PostgreSQL
- MySQL / MariaDB
- SQLite

## Issues

Bug reports, feature requests, and feedback are welcome on [GitHub Issues](https://github.com/Manmulsang/golra/issues).

## License

MIT License
