require 'pathname'
require_relative 'dir_explorer'


module FileScans
	class DirBuilder
		def initialize(folder, tag_file_writer: -> (dir) {} )
			@folder = folder
			@tag_file_writer = tag_file_writer
			on_dir = ->(dir, context) { context.add_dir(dir) }
			@explorer = DirExplorer.new(on_dir: on_dir, context: self)
		end

		def write_tag_file(dir)
			@tag_file_writer.call(dir)
			# tag_file = dir + 'tag'
			# tag_file.write('This is a tag file, please do NOT delete it') unless tag_file.exist?
		end

		def add_dir(dir)
			dir_str = dir.relative_path_from(@folder.target).to_s
			new_dir = @folder.path + dir_str
			new_dir.mkpath unless new_dir.exist?
			write_tag_file(new_dir)
			# (@folder.path + dir_str).mkpath
		end

		def call
			@folder.path.mkdir
			@explorer.call(@folder.target)
		end
		
	end
	
end
