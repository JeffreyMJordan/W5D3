require 'json'
require 'byebug'
class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    
    @req = req
    if @req.cookies['_rails_lite_app']
      @storage = JSON.parse(@req.cookies['_rails_lite_app'])
    else 
      @req.cookies['_rails_lite_app'] = "Something"
      @storage = {}
    end

  end

  def [](key)
    @storage[key]
  end

  def []=(key, val)
    @storage[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    json_var = @storage.to_json
    res.set_cookie("_rails_lite_app", json_var)
  end
end
