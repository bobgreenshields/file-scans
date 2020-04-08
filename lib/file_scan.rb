require 'pathname'
require 'yaml'
require_relative 'folder'

module FileScans
	class FileScan
		attr_reader :cloudroot

		def initialize
			@folders = []
		end

		def rcfile
			@rcfile ||= Pathname.new(ENV["HOME"]) + ".filescanrc"
			exit_no_rc unless @rcfile.exist?
		end

		def config_hash
			@config_hash ||= YAML.load(@rcfile.read)
		end

		def load_folders
			exit_if_config_key_missing("cloudroot")
			@cloudroot = Pathname.new(config_hash['cloudroot'])
			exit_cloudroot_not_exist unless cloudroot.directory?
			exit_if_config_key_missing("folders")
			config_hash['folders'].each { | folder_hash | load_folder(folder_hash: folder_hash,
																																cloudroot: @cloudroot) }
		end

		def load_folder(folder_hash: , cloudroot: )
			exit_if_folder_key_missing(key: "name", hash: folder_hash)
			exit_if_folder_key_missing(key: "target", hash: folder_hash)
			target = Pathname.new(folder_hash["target"])
			exit_folder_target_not_exist(target) unless target.exist?
			@folders << Folder.new(name: folder_hash["name"], target: target,
														 cloudroot: cloudroot)
			self
		end

		def folders
			return enum_for(:folders) unless block_given?
			@folders.each { |folder| yield folder}
		end

		def exit_no_rc
			STDERR.puts "Was expecting to find a config file called .filescan"
			STDERR.puts "at #{@rcfile}"
			STDERR.puts "but one could not be found"
			exit(65)
		end

		def exit_if_config_key_missing(key)
			return if config_hash.key?(key)
			STDERR.puts "Looking in the config file for a key called #{key}"
			STDERR.puts "but none could be found"
			exit(66)
		end

		def exit_cloudroot_not_exist
			STDERR.puts "Looking for the cloudroot directory"
			STDERR.puts "at #{@cloudroot} but it could not be found"
			exit(67)
		end

		def exit_folder_target_not_exist(target)
			STDERR.puts "Looking for the target directory"
			STDERR.puts "at #{target} but it could not be found"
			exit(68)
		end

		def exit_if_folder_key_missing(key: ,hash:)
			return if hash.key?(key)
			STDERR.puts "Looking in the folder info for a key called #{key}"
			STDERR.puts "but none could be found"
			exit(69)
		end
	end


end
