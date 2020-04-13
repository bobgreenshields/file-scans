require 'pathname'
require_relative 'dir_explorer'
require_relative 'scan_result'

module FileScans
	class NewDirScanner

		def initialize(folder)
			@folder = folder
			@result = ScanResult.new(@folder)
			on_dir = ->(dir, context) { context.add_dir_if_new(dir) }
			@explorer = DirExplorer.new(on_dir: on_dir, context: self)
		end

		def root
			@folder.target
		end

		def target
			@folder.path
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
