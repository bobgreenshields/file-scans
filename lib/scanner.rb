require 'pathname'
require_relative 'dir_explorer'
require_relative 'scan_result'

module FileScans
	class Scanner

		def initialize(folder)
			@folder = folder
			@result = ScanResult.new(@folder)
			on_file = ->(file, context) { context.add_file(file) }
			on_dir = ->(dir, context) { context.add_dir_if_new(dir) }
			@explorer = DirExplorer.new(on_file: on_file, on_dir: on_dir, context: self)
		end

		def root
			@folder.path
		end

		def target
			@folder.target
		end

		def tagfile?(file)
			# puts "checking #{file}"
			# puts "basename = #{Pathname.new(file).basename}"
			# result = Pathname.new(file).basename.to_s == 'tag' ? true : false
			# puts result.to_s
			Pathname.new(file).basename.to_s == 'tag'
		end

		def add_file(file)
			return if tagfile?(file)
			file_relative_path = file.relative_path_from(root).to_s
			if target_file_exist?(file_relative_path)
				@result.add_duplicate(file_relative_path)
			else
				@result.add_file(file_relative_path)
			end
		end

		def target_file_exist?(file_relative_path)
			(@folder.target + file_relative_path).exist?
		end

		def add_dir_if_new(dir)
			dir_str = dir.relative_path_from(root).to_s
			@result.add_new_dir(dir_str) unless (target + dir_str).directory?
		end

		def call
			@explorer.call(root)
			@result
		end

	end
end
