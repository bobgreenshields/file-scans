
module FileScans
	class DefaultScanFormatter
		def call(scan_result)
			result = files(scan_result)
		end

		def files(scan_result)
			case scan_result.files.count
			when 0
				["There are no files to move"]
			when 1
				result = ["There is one file"]
				result += scan_result.files.map(&:to_s)
				result << "To file"
			else
				result = ["There are #{scan_result.files.count} files"]
				result += scan_result.files.map(&:to_s)
				result << "To file"
			end
		end

		def new_dirs(scan_result)
			case scan_result.new_dirs.count
			when 0
				["There are no new dirs to create"]
			when 1
				result = ["There is one new dir"]
				result += scan_result.new_dirs.map(&:to_s)
				result << "To create"
			else
				result = ["There are #{scan_result.new_dirs.count} new dirs"]
				result += scan_result.new_dirs.map(&:to_s)
				result << "To create"
			end
		end

	end
	
end
