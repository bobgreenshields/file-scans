require 'pathname'
require_relative 'dir_explorer'
require_relative 'scan_result'

module FileScans
	class Scanner

		def initialize(folder)
			@folder = folder
			# @root = Pathname.new(root)
			# @target = Pathname.new(target)
			# @files = []
			# @new_dirs = []
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

		def add_file(file)
			@result.add_file(file.relative_path_from(root).to_s)
		end

		def add_dir_if_new(dir)
			dir_str = dir.relative_path_from(root).to_s
			@result.add_new_dir(dir_str) unless (target + dir_str).directory?
		end

		def scan
			@explorer.call(root)
			@result
		end

	end
end
