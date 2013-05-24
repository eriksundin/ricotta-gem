
command :'install:xcode' do |c|
  c.syntax = "ricotta install:xcode [options]"
  c.summary = "Fetch translations from Ricotta and install them into an Xcode project"
  c.description = "Execute this command in the root of the Xcode project."
  c.option '-u', '--url URL', "Ricotta application URL"
  c.option '-p', '--project PROJECT', "The Ricotta project"
  c.option '-l', '--language LANGUAGE', "Comma separated list of language codes"
  c.option '--subset SUBSET', "Subset name"
  c.option '--name_token NAMETOKEN', "A token within the translations to install as the localized CFBundleDisplayName"
  c.option '--lproj_dir LPROJDIR', "Home dir of the localized Xcode project folders (default: scans the working directory)"
  c.option '--template TEMPLATE', "The template (default: 'localizable_strings_padding')"
  c.option '--branch BRANCH', "The branch name (default: 'trunk')"
  
  c.action do |args, options|
    options.default :branch => 'trunk', :template => 'localizable_strings_padding'
    
    global_config = Ricotta::Configuration::Config.new(options.config)
    options.url = global_config[:url] unless options.url
    options.project = global_config[:project] unless options.project
    options.language = global_config[:language] unless options.language
    options.subset = global_config[:subset] unless options.subset
    options.template = global_config[:template] if global_config[:template] and options.template.eql?('localizable_strings_padding')
    options.branch = global_config[:branch] if global_config[:branch] and options.branch.eql?('trunk')
    
    options.name_token = global_config[:name_token] unless options.name_token
    options.lproj_dir = global_config[:lproj_dir] unless options.lproj_dir
    
    determine_url! unless @url = options.url
    determine_project! unless @project = options.project
    determine_language! unless @language = options.language
    
    unless @resource_path = options.lproj_dir 
      resource_dir_lookup = Dir.glob('**/*.lproj').first    
      @resource_path = File.dirname(resource_dir_lookup) if resource_dir_lookup
    end
    
    determine_resource_path! unless @resource_path
    @resource_path = File.expand_path(@resource_path)
    say_error "The directory #{@resource_path} does not exist" and abort unless File.directory?(@resource_path)
    
    languages = @language.split(',')
    client = Ricotta::Fetcher::Client.new(@url)
    
    languages.each do |language|
      say_ok "processing #{language}"
      response = client.fetch(@project, options.branch, language, options.template, options.subset)
      case response.status
      when 200
        lproj_base_dir = "#{@resource_path}/#{language}.lproj"
        Dir.mkdir(lproj_base_dir) unless File.directory?(lproj_base_dir)
        strings_file = "#{lproj_base_dir}/Localizable.strings"
        File.open(strings_file, 'w') { |file| file.write("#{response.body}") }
        say_ok "created #{strings_file}"
      
        if options.name_token
          File.open(strings_file).each do |line|
            if line.start_with?(options.name_token)
              app_name = line.split('=').last.strip.split('"')[1]
              say_error "The token #{options.name_token} is missing or empty for language #{language}" and abort unless app_name.length > 0
              
              info_plist_strings = "#{lproj_base_dir}/InfoPlist.strings"
              File.open(info_plist_strings, 'w') { |file| file.write("CFBundleDisplayName=\"#{app_name}\";\n") }
              say_ok "created #{info_plist_strings} with CFBundleDisplayName '#{app_name}'"
              
              break
            end
          end
        end
      else
        say_error "Failed to download translations for #{language}: #{response.status} #{response.body}\n" and abort
      end
    end
    say_ok "translations for #{@project} installed"
  end
  
  private
  
  def determine_resource_path!
    @resource_path ||= ask "Destination for .lproj folders:"
  end
  
  def determine_url!
    @url ||= ask "Ricotta URL:"
  end

  def determine_project!
    @project ||= ask "Project:"
  end

  def determine_language!
    @language ||= ask "Language(s):"
  end

end
