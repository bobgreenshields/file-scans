require 'pathname'
# require 'yaml'
require_relative 'folder'
require_relative 'scanner'
require_relative 'dir_builder'
require_relative 'file_lister'

module FileScans
	class FileScan
		def initialize(config_hash)
			@config_hash = config_hash
			@folders = []
			@cloudroot = nil
			load_folders
		end

		def cloudroot
			return @cloudroot if @cloudroot
			@cloudroot = Pathname.new(@config_hash['cloudroot'])
			exit_if_dir_not_exist(name: "cloud dir", dir: @cloudroot)
			@cloudroot
		end

		def dirs
			folders do |folder|
				if folder.path.exist?
					if Scanner.new(folder).call.files?
						STDERR.puts "Cloud folder #{folder.path} contains files"
						STDERR.puts "please empty it before it can be rebuilt"
						return
					else
						folder.path.rmtree
					end
				end
				STDERR.puts "Building cloud folder #{folder.path}"
				DirBuilder.new(folder).call
			end
		end

		def files
			folders do |folder|
				STDERR.puts "Listing files from #{folder.target} into #{folder.name}.txt"
				FileLister.new(folder).call
			end
		end

		def load_folders
			@config_hash['folders'].each { | folder_hash | load_folder(folder_hash)}
		end

		def load_folder(folder_hash)
			name = folder_hash["name"]
			target = Pathname.new(folder_hash["target"])
			exit_if_dir_not_exist(name: "the target of folder #{name}", dir: target)
			@folders << Folder.new(name: name, target: target, cloudroot: cloudroot)
			self
		end

		def folders
			return enum_for(:folders) unless block_given?
			@folders.each { |folder| yield folder}
		end

		def exit_if_dir_not_exist(name: ,dir:)
			dir_path = Pathname.new(dir)
			return if dir_path.directory?
			STDERR.puts "Looking for #{name} at #{path}"
			if dir_path.exist?
				STDERR.puts "It is not a directory"
			else
				STDERR.puts "It does not exist"
			end
			exit(70)
		end

		# def exit_no_rc
		# 	STDERR.puts "Was expecting to find a config file called .filescan"
		# 	STDERR.puts "at #{@rcfile}"
		# 	STDERR.puts "but one could not be found"
		# 	exit(65)
		# end

		# def exit_if_config_key_missing(key)
		# 	return if @config_hash.key?(key)
		# 	STDERR.puts "Looking in the config file for a key called #{key}"
		# 	STDERR.puts "but none could be found"
		# 	exit(66)
		# end

		# def exit_cloudroot_not_exist
		# 	STDERR.puts "Looking for the cloudroot directory"
		# 	STDERR.puts "at #{@cloudroot} but it could not be found"
		# 	exit(67)
		# end

		# def exit_folder_target_not_exist(target)
		# 	STDERR.puts "Looking for the target directory"
		# 	STDERR.puts "at #{target} but it could not be found"
		# 	exit(68)
		# end

		# def exit_if_folder_key_missing(key: ,hash:)
		# 	return if hash.key?(key)
		# 	STDERR.puts "Looking in the folder info for a key called #{key}"
		# 	STDERR.puts "but none could be found"
		# 	exit(69)
		# end
	end


end
