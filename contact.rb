require 'rubygems'
require 'sinatra'
require 'pony'

# Load configuration from config.yml
CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'config.example.yml'))

EmailAddress = begin
  qtext = '[^\\x0d\\x22\\x5c\\x80-\\xff]'
  dtext = '[^\\x0d\\x5b-\\x5d\\x80-\\xff]'
  atom = '[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-' +
    '\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+'
  quoted_pair = '\\x5c[\\x00-\\x7f]'
  domain_literal = "\\x5b(?:#{dtext}|#{quoted_pair})*\\x5d"
  quoted_string = "\\x22(?:#{qtext}|#{quoted_pair})*\\x22"
  domain_ref = atom
  sub_domain = "(?:#{domain_ref}|#{domain_literal})"
  word = "(?:#{atom}|#{quoted_string})"
  domain = "#{sub_domain}(?:\\x2e#{sub_domain})*"
  local_part = "#{word}(?:\\x2e#{word})*"
  addr_spec = "#{local_part}\\x40#{domain}"
  pattern = /\A#{addr_spec}\z/
end

# Define default Pony options
Pony.options = {
  :via         => CONFIG['via'],
  :via_options => CONFIG['via_options']
}

get '/send/:key' do
  # Get the default settings from the configuration
  # using the API key
  settings = CONFIG['targets'][params[:key]] or raise 'Invalid API key'

  # Combine fields from_name from_email into field from
  if !params['from'] && params['from_name'] && params['from_email']
    params['from'] = '%s <%s>' % [params.delete('from_name'), params.delete('from_email')]
  end

  # Validate e-mail addresses
  raise "The 'cc' address (#{params['cc']}) is invalid" unless !params['cc'] || params['cc'] =~ EmailAddress

  # Merge in the from, cc and subject fields
  params.each_pair do |key, value|
    settings.merge!({ key => value }) if key =~ /^(from|cc|subject)$/
  end

  # Interpolate other variables in the body format template
  settings['body'] = settings['body'].gsub(/\{(\w+)\}/) { |m| params[$1] }

  # Send the e-mail
  Pony.mail settings

  # Redirect to specified return URL
  redirect settings[:return_url]
end

