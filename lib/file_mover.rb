require 'pathname'
require 'fileutils'
require_relative 'scan_result'

module FileScans
	class FileMover
		attr_writer :on_file_exist, :on_file_move, :on_new_dir_exist, :on_new_dir_create

		def initialize(scan_result)
			@scan_result = scan_result
			@on_file_exist = ->(file, target_file) {}
			@on_file_move = ->(file, target_file) {}
			@on_new_dir_exist = ->(dir, target_dir) {}
			@on_new_dir_create = ->(dir, target_dir) {}
		end

		def call
			@scan_result.new_dirs do | dir |
				target_dir = @scan_result.target + dir
				if target_dir.exist?
					@on_new_dir_exist.call(dir, target_dir.to_s)
				else
					target_dir.mkpath
					@on_new_dir_create.call(dir, target_dir.to_s)
				end
				# target_dir.mkpath unless target_dir.exist?
			end
			@scan_result.files do | file |
				source_file = @scan_result.path + file
				target_file = @scan_result.target + file
				if target_file.exist?
					@on_file_exist.call(file, target_file.to_s)
				else
					FileUtils.mv(source, target_file)
					# source_file.rename(target_file)
					@on_file_move.call(file, target_file.to_s)
				end
				# source_file.rename(target_file) unless target_file.exist?
			end
		end
		
	end	
end
