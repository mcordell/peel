# Peel

>A gem for token authorization of [Grape](https://github.com/intridea/grap) APIs.

__Peel__ is a gem to make token based authentication in Grape
APIs easier. It uses [warden](https://github.com/hassox/warden) under the hood
to handle authentication of the requests. Finally, it leverages [JSON web tokens](http://jwt.io/)
for the API tokens. It is particularly geared towards clients that can't keep
secrets, namely single-page apps.


## Installation

Add this line to your application's Gemfile:

    gem 'peel'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peel

## Usage

###ActiveRecord Model

Include the ActiveRecord module in your user model:

```ruby
class User < ActiveRecord::Base
  include Groken::ActiveRecord
end
```

The model that it is included in must have `email` and `token` fields.


###API Side

To create an API with the methods protected by token authentication, subclass
the Peel::API :

```ruby
class ProtectedAPI < Peel::API
  get '/protected' do
    'secret stuff'
  end
end
```

To get access to warden related helpers throughout your API mixin the
Peel::ApiInclude like so:

```ruby
class YourAPI < Grape::API
  include Peel::ApiInclude
end
```

You can mount the protected API within your base Grape::API (or mount it
seprately via Rails or other):

```ruby
class YourAPI < Grape::API
  include Peel::ApiInclude
  mount ProtectedAPI

  get '/' do
    'Not secret'
  end
end
```

Now `GET`ting '/protected' will fail when proper authentication tokens are not
presented. `GET`tting '/' is unprotected and freely accessible.

###Client-Side

- Add the tokens in the header as ```'Authorization' => token```
- You can store the tokens in `localStorage`, session storage, or client
  cookies. [See here for
  more](https://auth0.com/blog/2014/01/27/ten-things-you-should-know-about-tokens-and-cookies/#token-storage)


###Other Important Info

- Serve your API over SSL. If the tokens are intercepted en-route to your user, a [man-in-the-middle attack](http://en.wikipedia.org/wiki/Man-in-the-middle_attack) is trival.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
