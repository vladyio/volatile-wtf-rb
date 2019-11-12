# VolatileWTF

A Ruby wrapper for [Volatile](https://volatile.wtf/), a key-value pair API that everyone can use.

## Installation

`gem install volatile_wtf`

or for a Gemfile:

```ruby
gem 'volatile_wtf'
```

```bash
bundle install
```

## Usage

Don't forget to require the gem:

```ruby
require 'volatile_wtf'
```

### Initialize storage object

```ruby
Storage = Volatile::Storage.new
```

### Create a key-value pair

```ruby
Storage['user_name'] = 'Alice' # => 'Alice'
```

If you want to create a pair independent from your Storage, use `Storage.push`:

```ruby
Storage.push('random_key', 'random_val')
```

You can use symbols as keys, but you'll still have to use strings to get values.

### Retrieve a value by key

Using `#[](key)` retrieves a key from current Storage instance:

```ruby
Storage['user_name'] # => 'Alice'
```

If you want to retrieve a value by a custom key independent from your Storage, use `Storage.pull`:

```ruby
Storage.pull('random_key') # => 'random_val'
```

### `created` and `modified` timestamps

[Volatile](https://volatile.wtf/) allows to get information about when a key-pair was created and modified.

- Created
  ```ruby
  Storage.created('user_name') # => 2019-11-12 16:55:45 +0300
  ```
- Modified

  ```ruby
  Storage.modified('user_name') # => 2019-11-12 17:40:45 +0300
  ```

### Salted keys (or simply key prefixes)

Salt is used for keys to make them trackable within this gem.

#### Passing your own salt

By default, Storage is initialized with salt equal to `SecureRandom.hex[0..5]` and makes keys look like `0123ab_some` instead of just `some`. You can pass your own salt value like this:

```ruby
Storage = Volatile::Storage.new('my_own_salt')
```

#### Retrieving a real key name

If you want to get a real (salted) key name, you should use `Storage#real_key`:

```ruby
Storage.real_key('nice_key') # => '0123ab_nice_key'
```

Don't forget that every `Volatile::Storage.new` has its own salt value.

### Hash conversion (`#to_h`)

By default, `#to_h` generates a hash with friendly keys without salt:

```ruby
{
    "user_name" => "Alice",
        "email" => "alice@example.com"
}
```

To generate a hash with real keys, use `with_real_keys: true` parameter:

```ruby
Storage.to_h(with_real_keys: true)
```

This will return the following result:

```ruby
{
    "2365fc_user_name" => "Alice",
        "2365fc_email" => "alice@example.com"
}
```

