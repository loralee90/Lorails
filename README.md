# Lorails

Lorails is a lightweight MVC framework written in Ruby and inspired by Rails. `ControllerBase` provides a base controller class, and `Router` provides basic routing capabilities.

## ControllerBase

### Key Features

Custom controllers that inherit `ControllerBase` can use the following methods:

- `redirect_to(url)`: Redirects to the specified url
-  `render(template_name)`: Renders the template located at `app/views/<controller_name>/<template_name>.html.erb`
- `render_content(content, content_type)`: Renders content with the specified content type
-  `session`: A hash that is saved as a cookie and persists throughout the user's session
- `flash` and  `flash.now`: Hashes that are saved as cookies and persist through two HTTP response/request cycles and one HTTP response/request cycle, respectively
- `protect_from_forgery`: Checks for an authenticity token from any forms/submitted data when added to custom controllers. Token can be added to forms in your views as follows:

```html
<input
  type="hidden"
  name="authenticity_token"
  value="<%= form_authenticity_token %>" />
```

## Router

The `Router` enables you to map routes to custom controllers:

```ruby
require_relative '../lib/router'

router = Router.new
router.draw do
  get Regexp.new("^/users/new$"), UsersController, :new
  post Regexp.new("^/users$"), UsersController, :create
  get Regexp.new("^/users/(?<user_id>\\d+)$"), UsersController, :show
  delete Regexp.new("^/users/(?<user_id>\\d+)$"),
         UsersController, :destroy
  get Regexp.new("^/$"), UsersController, :index
end
```

## Rack Middleware

- `ShowExceptions`: Renders detailed error messages that contain the following:
  - The stack trace
  - A preview of the source code where the exception was raised
  - The exception message
- `Static`: Makes static assets such as images, JavaScript, and CSS files available client-side

## Future Features

- An integrated ORM framework
- An installable Lorails gem
