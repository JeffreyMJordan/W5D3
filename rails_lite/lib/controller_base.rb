require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params, :already_built_response

  # Setup the controller
  def initialize(req, res)
    @res = res 
    @req = req
    @session = Session.new(@req)
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already rendered" if @already_built_response
    @res.status = 302
    @res.header['location'] = url
    session.store_session(@res)
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already rendered" if @already_built_response
    @res['Content-Type'] = content_type 
    @res.write(content)
    session.store_session(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content

  #Use ERB.new 
  #Use File.read
  #Set a variable to what we get 
  def render(template_name)
    dir_path = File.dirname(__FILE__)
    file_path = File.join(dir_path, "..", "views", self.class.name.underscore,  "#{template_name}.html.erb")
    x = File.read(file_path)
    self.render_content(ERB.new(x).result(binding), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

