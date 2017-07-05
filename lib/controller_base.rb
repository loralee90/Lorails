require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
    @already_built_response = false
    @@protect_form_forgery ||= false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "double render error" if already_built_response?

    @res.location = (url)
    @res.status = 302

    @already_built_response = true

    session.store_session(@res)
    flash.store_flash(@res)

    nil
  end

  def render_content(content, content_type)
    raise "double render error" if already_built_response?

    @res['Content-Type'] = content_type
    @res.write(content)

    @already_built_response = true

    session.store_session(@res)
    flash.store_flash(@res)

    nil
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    file = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(file).result(binding)
    render_content(template, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    if protect_from_forgery? && req.request_method != "GET"
      check_authenticity_token
    else
      form_authenticity_token
    end

    self.send(name)
    render(name) unless already_built_response?

    nil
  end

  def form_authenticity_token
   @token ||= generate_authenticity_token
   res.set_cookie('authenticity_token', value: @token, path: '/')
   @token
 end

 protected

 def self.protect_from_forgery
   @@protect_from_forgery = true
 end

 private

 attr_accessor :already_built_response

 def protect_from_forgery?
   @@protect_from_forgery
 end

 def check_authenticity_token
   cookie = @req.cookies["authenticity_token"]
   unless cookie && cookie == params["authenticity_token"]
     raise "Invalid authenticity token"
   end
 end

 def generate_authenticity_token
   SecureRandom.urlsafe_base64(16)
 end
end
