require 'json'

class Session
  def initialize(req)
    @session_cookie = req.cookies["_lorails_app"] ? JSON.parse(req.cookies["_lorails_app"]) : {}
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  def store_session(res)
    @session_cookie[:path] = "/"
    res.set_cookie("_lorails_app", @session_cookie.to_json)
  end
end
