require_relative '../lib/scanner'
require_relative '../lib/scan_result'
require_relative '../lib/folder'

include FileScans

describe Scanner do
	let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
	let(:folder) { folder = Folder.new(name: 'scanner-source', cloudroot: fixture,
													target: fixture + 'scanner-target' ) }
	let(:scanner) { Scanner.new(folder) }
	describe '#call' do
		it 'returns a ScanResult' do
			expect(scanner.call).to be_a ScanResult
		end
		it 'scans and populates the files in the scanresult' do
			result = scanner.call
			expected = ["filing/car/new_dir_3/file2.txt", "filing/file1.txt",
							 "filing/house/file3.txt", "inv/dgs/file4.txt",
							 "inv/fpl/houses/new_dir_1/file5.txt"]
			files = result.files.inject([]) { |array, file| array << file }
			expect(files).to eql expected
		end
		it 'scans and populates the new dirs in the scanresult' do
			result = scanner.call
			expected = ["filing/car/new_dir_3", "filing/new_dir_2",
							 "inv/dgs/new_dir_4", "inv/fpl/houses/new_dir_1"]
			new_dirs = result.new_dirs.inject([]) { |array, new_dir| array << new_dir }
			expect(new_dirs).to eql expected
		end
		it 'scans and populates the duplicates in the scanresult' do
			result = scanner.call
			expected = ["filing/car/7.txt", "inv/dgs/2.txt"]
			duplicates = result.duplicates.inject([]) { |array, new_dir| array << new_dir }
			expect(duplicates).to eql expected
		end

	end

end
