o[![CircleCI](https://circleci.com/gh/marcinruszkiewicz/where_chain.svg?style=svg)](https://circleci.com/gh/marcinruszkiewicz/where_chain)

# WhereChain

In Rails, we usually use Active Record, which allows us to escape from writing SQL code like this `SELECT * FROM posts WHERE posts.name = 'Foo'` and allows us to write `Post.where(name: 'Foo')` instead. However, this has always been limited to matching equality, so you still have to write `Post.where('comments > ?', 5)` to get Posts that have more than 5 comments. 

In the older versions, you also had to write `Post.where('name IS NOT null')` to do a negation. Rails 4.0 added a class called `WhereChain` that added some new possibilities](), one of which was a `not` method. The proper way to write  became `Post.where.not(name: nil)` instead.

Within the same comment there were also two new methods that [didn't survive to the release of Rails 4.0](https://github.com/rails/rails/commit/8d02afeaee8993bd0fde69687fdd9bf30921e805) - `.like` and `.not_like`. As you can read in this commit discussion, there has been work made to bring them back, like the [activerecord-like](https://github.com/ReneB/activerecord-like) gem or [Squeel](https://github.com/activerecord-hackery/squeel), but these has their own problems - activerecord-like only adds `.like` and `.not_like` back and the latest version is locked to Active Record 5; and Squeel provides a whole new query DSL, which not everyone will like. There was actually a pull request adding `.gt` and other [inequality methods](https://github.com/rails/rails/pull/8453), which was closed even faster than the first one.

This gem brings these two methods back and extends WhereChain with additional methods: `.gt`, `.gte`, `.lt` and `.lte`, so that by using it you can replace the SQL strings like `Post.where('comments > 5')` with `Post.where.gt(comments: 5)`.

WhereChain depends on the Active Record gem in a version higher than 4.2, due to problems with Ruby versions lesser than 2.4. Rails 4.2 is already the version that's being maintained, so you probably should not use an earlier one anyway. The gem is tested on the latest Ruby and all current Rails versions - 4.2, 5.0, 5.1 and 5.2 RC 1.

## Usage

Some examples of using the gem and what can be replaced with it:

| Rails SQL string | with WhereChain |
|------------|-----------------|
|`Post.where('comments > ?', 5)` | `Post.where.gt(comments: 5)` |
|`Post.where('comments >= ?', 5)` | `Post.where.gte(comments: 5)` |
|`Post.where('comments < ?', 5)` | `Post.where.lt(comments: 5)` |
|`Post.where('comments <= ?', 5)` | `Post.where.lte(comments: 5)` |
|`Post.where('name LIKE ?', "%foo%")` | `Post.where.like(name: "%foo%")` |
|`Post.where('name NOT LIKE ?', "%foo%")` | `Post.where.unlike(name: "%foo%")` |
|`Post.where('comments > ? AND shares > ?', 5, 10)` | `Post.where.gt({ comments: 5, shares: 10 })` |
|`Post.where('comments > ? OR shares > ?', 5, 10)` | `Post.where.gt(comments: 5).or(Post.where.gt(shares: 10))` |

You can now also chain the methods in your Active Record queries:

```ruby
Post.where.not.gt(comments: 5).where.like(name: '%foo%')
```

This, however, will **NOT** work at all:

```ruby
Post.gt(comments: 5).like(name: '%foo%')
Post.where.gt(comments: 5).lt(comments: 10)
```

You need to prepend each of the new methods with either `.where` or `.where.not` for them to work.

All the methods accept all proper types as values, except Arrays and Hashes. These will **not** work and will raise a relevant ArgumentError exception:

```ruby
Post.where.gt(comments: [1, 2, 3])
Post.where.gt(comments: { bad: :thing })

ArgumentError: The value passed to this method should be a valid type.

Post.where.gt('comments > ?', 5)
Post.where.gt([{number: 5}, 'name > ?'], 'abc')

ArgumentError: This method requires a Hash as an argument.
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'where_chain'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install where_chain
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
