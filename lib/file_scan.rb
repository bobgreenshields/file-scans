require 'pathname'
require 'yaml'
require_relative 'folder'

module FileScans
	class FileScan
		def initialize
			@folders = []
		end

		def rcfile
			@rcfile ||= Pathname.new(ENV["HOME"]) + ".filescanrc"
			exit_no_rc unless @rcfile.exist?
		end

		def config_hash
			@config_hash ||= YAML.load(rcfile.read)
		end

		def load_folders
			exit_missing_config_key("cloudroot") unless config_hash.key?('cloudroot')
			@cloudroot = Pathname.new(config_hash['cloudroot'])
			exit_cloudroot_not_exist unless cloudroot.directory?
			exit_missing_config_key("folders") unless config_hash.key?('folders')
			config_hash['folders'].each { | folder_hash | load_folder(folder_hash) }
		end

		def load_folder(folder_hash)
			exit_missing_config_key("name") unless config_hash.key?('name')
			exit_missing_config_key("target") unless config_hash.key?('target')
			target = Pathname.new(name: config_hash["name"])
			exit_folder_target_not_exist(target) unless target.exist?
			@folders << Folder.new(name: config_hash["name"], target: target, 
														 cloudroot: @cloudroot)
			self
		end
	end


end
