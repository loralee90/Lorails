require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_lorails_app_flash']
    @now = cookie ? JSON.parse(cookie) : {}
    @flash = {}
  end

  def [](key)
    @now[key] || @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

  def store_flash(res)
    res.set_cookie('_lorails_app_flash', value: @flash.to_json, path: '/')
  end
end
