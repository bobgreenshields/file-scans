
module FileScans
	class DefaultScanFormatter
		def call(scan_result)
			# result = files_proc(scan_result.files.count).call(scan_result)
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

	end
	
end
