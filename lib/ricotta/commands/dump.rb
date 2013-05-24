require 'yaml'

command :'dump' do |c|
  c.syntax = "ricotta dump [options]"
  c.summary = "Dump translations from Ricotta into local files."
  c.description = "Fetched translations will written to one file per language"
  c.option '-u', '--url URL', "Ricotta application URL"
  c.option '-p', '--project PROJECT', "The Ricotta project"
  c.option '-l', '--language LANGUAGE', "Comma separated list of language codes"
  c.option '-T', '--template TEMPLATE', "Template name"
  c.option '--subset SUBSET', "The subset name"
  c.option '--branch BRANCH', "The branch name ('trunk' if not set)"
  c.option '--config FILE', "Load default options from a configuration file"
  
  c.action do |args, options|
    options.default :branch => 'trunk'
    
    global_config = Ricotta::Configuration::Config.new(options.config)
    options.url = global_config[:url] unless options.url
    options.project = global_config[:project] unless options.project
    options.language = global_config[:language] unless options.language
    options.subset = global_config[:subset] unless options.subset
    options.template = global_config[:template] unless options.template
    options.branch = global_config[:branch] if global_config[:branch] and options.branch.eql?('trunk')
    
    
    determine_url! unless @url = options.url
    determine_project! unless @project = options.project
    determine_language! unless @language = options.language
    determine_template! unless @template = options.template
    
    languages = @language.split(',')
    
    client = Ricotta::Fetcher::Client.new(@url)
    
    languages.each do |language|
      
      response = client.fetch(@project, options.branch, language, @template, options.subset)
      case response.status
      when 200
        output = "#{@project}.#{language}"
        File.open(output, 'w') { |file| file.write("#{response.body}") }
        say_ok "#{language} translations downloaded to #{output}"
      else
        say_error "Failed to download translations for #{language}: #{response.status} #{response.body}\n"
        abort
      end
    end
  end

  private

  def determine_url!
    @url ||= ask "Ricotta URL:"
  end

  def determine_project!
    @project ||= ask "Project:"
  end

  def determine_template!
    @template ||= ask "Template:"
  end

  def determine_language!
    @language ||= ask "Language(s):"
  end

end