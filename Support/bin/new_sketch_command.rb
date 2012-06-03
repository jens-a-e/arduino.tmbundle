#!/usr/bin/env ruby
# 
#  new_sketch_command.rb
#  Arduino.tmbundle
#  
#  Created by jens alexander ewald on 2012-06-03.
#  Copyleft 2012 ififelse.net.
# 

require 'init_bundle_support'

# Try to load the preference file from the installation
preferences = File.join ENV["HOME"],"Library/Arduino/preferences.txt"
sketchbook_path = File.read(preferences).match(/sketchbook.path=(.+)$/)[1]
SKETCHBOOK_PATH = sketchbook_path || File.join(ENV["HOME"], "Documents/Arduino")

# Get a sketch name:
DEFAULT_SKETCHNAME = "MyFancyProjectName"
options = {
    :title => "Create a new Arduino Project", 
    :default => DEFAULT_SKETCHNAME,
    :prompt => "Name of the Project:",
    :button1 => 'Create',
    :button2 => 'Cancel'
}
sketch_name = TextMate::UI.request_string options
TextMate.exit_discard unless sketch_name # exit, if do not have a name

# Sanitize the name, so we will not have ay path problems
def sanitize_sketch_name(name)
  # Replace all Non-Word characters with an underscore & reduce those
  name.gsub(/\W/,"_").gsub(/_+/,"_")
end
sketch_name = sanitize_sketch_name(sketch_name)

# Do we want another location than th default?
to_defaultlocation = TextMate::UI.alert(
  :informational,
  "Save to this sketchbook path:",
  sketchbook_path,
  "Yes","No"
)

if to_defaultlocation == "No"
  options = {
    :directory => SKETCHBOOK_PATH,
    :only_directories => true,
    :text => "Please select a destination for your project",
    :title => "Select destination"
  }
  dir = TextMate::UI.request_file options
end
dir = dir || SKETCHBOOK_PATH

# ======================
# = Paths & File names =
# ======================
sketch_file = "#{sketch_name}.ino"
sketch_path = File.join dir, sketch_name
full_sketch_path = File.join sketch_path, sketch_file

# ============
# = Precheck =
# ============
def abort
  TextMate.exit_show_tool_tip("Bootstrpping project aborted!")
end

# Alert & exit if sketch already exists
_go_on = ""
if File.exists?(sketch_path)
  _go_on = TextMate::UI.alert(:warning,"Initializing Project","The project #{sketch_name} already exits! If you continue it will be overriden!","OK","Cancel")
  abort unless _go_on == "OK"
end

# Make Sure, we are sure!
if File.exists?(sketch_path)
  _go_on = TextMate::UI.alert(:warning,"ARE YOUR SURE?","If you continue it will be overriden!","OK","Cancel")
  abort unless _go_on == "OK"
end


# ===============================
# = Bootstrapping a new project =
# ===============================
# Make the directory and touch the file
`mkdir -p "#{sketch_path}" && touch #{full_sketch_path}`


# ================================
# = Inject from the Template if  =
# ================================
def get_template(name)
  tmpl_folder   = File.dirname(ENV['TM_BUNDLE_SUPPORT'])
  template_path = File.join tmpl_folder,"Templates","Arduino.tmTemplate","sketch.ino"
  replacements  = {
    '${TM_NEW_FILE_BASENAME}' => name,
    '${TM_DATE}' => `date +%Y-%m-%d`,
    '${TM_FULLNAME}' => ENV['TM_FULLNAME']
  }
  code = File.read(template_path)
  code.gsub(/\$\{TM_NEW_FILE_BASENAME\}|\$\{TM_DATE\}|\$\{TM_FULLNAME\}/) do |match|
    replacements[match.to_s]
  end
end

# Make a sketch file:
sketch_file_handler = File.new(full_sketch_path,"w")
sketch_file_handler.write TextMate.selected_text || get_template(sketch_file)
sketch_file_handler.close

# Add a TexteMate Project File
proj_template = File.read(File.join ENV['TM_BUNDLE_SUPPORT'],"project_templates","tmproj.template" )
project_file = File.new(File.join(sketch_path,"#{sketch_name}.tmproj"),"w")
project_file.write(proj_template.gsub(/\$\{PROJECT_NAME\}/, sketch_name))
project_file.close()

# Open it
`open #{project_file.path}`

# .. and exit
TextMate.exit_discard