require 'gems/sass-3.2.3/lib/sass'
require 'gems/chunky_png-1.2.6/lib/chunky_png'
require 'gems/compass-0.12.2/lib/compass'

def compileSingleScss(template, params, load_paths)

  Compass.add_configuration(
      {
          :project_path => params['scss_folder']
      },
      'custom' # A name for the configuration, can be anything you want
  )

  convertedParams = Hash.new

  load_paths.add(File.join(Compass.base_directory, 'frameworks/compass/stylesheets'))
  load_paths.add(File.join(Compass.base_directory, 'frameworks/blueprint/stylesheets'))

  convertedParams[:cache] = false
  convertedParams[:load_paths] = load_paths
  convertedParams[:debug_info] = params['debug_info']
  convertedParams[:line_comments] = params['line_comments']
  convertedParams[:style] = params['style'].to_sym
  convertedParams[:syntax] = params['syntax'].to_sym
  convertedParams[:filename] = params['file_path']

  answer = Hash.new

  begin
    sass = Sass::Engine.new(template, convertedParams)
    answer['scss'] = sass.render
    answer['result'] = true
  rescue Sass::SyntaxError => e
    #e.sass_template = template
    answer['error'] = Sass::SyntaxError.exception_to_css(e, :full_exception => true)
    answer['short_error'] = e.sass_backtrace_str
    answer['result'] = false
  end

  return answer
end