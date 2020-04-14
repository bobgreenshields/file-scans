require 'pathname'
# require 'yaml'
require_relative 'folder'
require_relative 'scanner'
require_relative 'new_dir_scanner'
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
			%i(files sync_dirs rebuild_dirs move scan).each do |method_name|
				self.send(method_name) if options.include?(method_name)
			end
		end

		def sync_dirs
			STDERR.puts
			folders do |folder|
				folder.path.mkpath unless folder.path.exist?
				NewDirScanner.new(folder).call.new_dirs do |new_dir|
					new_dir_path = folder.path + new_dir
					if new_dir_path.exist?
						STDERR.puts "Was going to make #{new_dir} in folder #{folder.name} but it already exists"
					else
						new_dir_path.mkpath
						STDERR.puts "Making #{new_dir} in folder #{folder.name}"
					end
				end
			end
		end

		def rebuild_dirs
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
				exit_if_dir_not_exist(name: "the cloud folder #{folder.name}", dir: folder.path)
				STDERR.puts "==== Scanning folder #{folder.name} ===="
				sr = Scanner.new(folder).call
				STDERR.puts formatter.call(sr)
			end
		end

		def move
			STDERR.puts
			formatter = @formatter.new
			folders do |folder|
				exit_if_dir_not_exist(name: "the cloud folder #{folder.name}", dir: folder.path)
				STDERR.puts "==== Scanning folder #{folder.name} ===="
				sr = Scanner.new(folder).call
				STDERR.puts formatter.call(sr)
				sr.files do |file|
					move_file(file_relative: file, source_dir: folder.path, target_dir: folder.target)
					STDERR.puts "Moving #{file}"
				end
			end
		end

		def move_file(file_relative: , source_dir: , target_dir: )
			source_path = Pathname.new(source_dir) + file_relative
			target_path = Pathname.new(target_dir) + file_relative
			raise RuntimeError,
				"Wanting to move file from #{source_path} but it doesn't exist!" \
				unless source_path.exist?
			raise RuntimeError,
				"Wanting to move file to #{target_path} but it already exists!" \
				if target_path.exist?
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
			STDERR.puts "Looking for #{name} at #{dir_path}"
			if dir_path.exist?
				STDERR.puts "It is not a directory"
			else
				STDERR.puts "It does not exist"
			end
			exit(72)
		end

	end
end
