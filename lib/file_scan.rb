require 'pathname'
# require 'yaml'
require_relative 'folder'
require_relative 'scanner'
require_relative 'dir_builder'
require_relative 'file_lister'
require_relative 'default_scan_formatter'

module FileScans
	class FileScan
		def initialize(config_hash)
			@config_hash = config_hash
			@folders = nil
			@cloudroot = nil
			@formatter = DefaultScanFormatter
		end

		def cloudroot
			return @cloudroot if @cloudroot
			@cloudroot = Pathname.new(@config_hash['cloudroot'])
			exit_if_dir_not_exist(name: "cloud dir", dir: @cloudroot)
			@cloudroot
		end

		def cloudpath(path_or_str)
			path = Pathname.new(path_or_str)
			path.relative_path_from(cloudroot)
		end

		def call(options)
			options.delete(:scan) if options.include?(:move)
			%i(files build_dirs move scan).each do |method_name|
				self.send(method_name) if options.include?(method_name)
			end
		end

		def build_dirs
			STDERR.puts
			folders do |folder|
				if folder.path.exist?
					if Scanner.new(folder).call.files?
						STDERR.puts "Cloud folder #{cloudpath(folder.path)} contains files"
						STDERR.puts "please empty it before it can be rebuilt"
						STDERR.puts
						next
					else
						folder.path.rmtree
					end
				end
				STDERR.puts "Building cloud folder #{cloudpath(folder.path)}"
				STDERR.puts
				DirBuilder.new(folder).call
			end
		end

		def files
			STDERR.puts
			folders do |folder|
				STDERR.puts "Listing files from #{folder.target} into #{folder.name}.txt"
				FileLister.new(folder).call
			end
		end

		def scan
			STDERR.puts
			formatter = @formatter.new
			folders do |folder|
				STDERR.puts "==== Scanning folder #{folder.name} ===="
				sr = Scanner.new(folder).call
				STDERR.puts formatter.call(sr)
			end
		end

		def move
			puts "MOVE called"
		end

		def load_folder(folder_hash)
			name = folder_hash["name"]
			target = Pathname.new(folder_hash["target"])
			exit_if_dir_not_exist(name: "the target of folder #{name}", dir: target)
			Folder.new(name: name, target: target, cloudroot: cloudroot)
		end

		def folders
			@folders ||= @config_hash['folders'].map { |folder_hash| load_folder(folder_hash) }
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
