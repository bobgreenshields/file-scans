require 'pathname'

module FileScans
	class FileLister
		def initialize(folder)
			@folder = folder
		end

		def target
			@folder.target.to_s.gsub(' ', '\ ')
		end

		def name
			@folder.files_list.to_s.gsub(' ', '\ ')
		end

		def cut_start
			@folder.target.to_s.length + 1
		end

		def cmd_str
			find_str = %W(find #{target} -type f)
			cut_str = %W(| cut -c #{cut_start}-)
			sort_str = %W(| sort)
			to_file_str = %W(> #{name})
			(find_str + cut_str + sort_str + to_file_str).join(' ')
		end
	end
end
