require_relative '../lib/scan_result'
require_relative '../lib/default_scan_formatter'
require_relative '../lib/folder'

include FileScans

describe DefaultScanFormatter do
	describe '#files_proc' do
		let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
		let(:folder) do
			Folder.new(name: 'test', cloudroot: fixture, target: fixture + 'target' )
		end
		let(:formatter) { DefaultScanFormatter.new }
		context 'with no files' do
			it 'returns an array with the correct string' do
				sr = ScanResult.new(folder)
				expect(formatter.files(sr)).to eql ["There are no files to move"]
			end
		end
		context 'with one file' do
			it 'returns the single file string and the file name' do
				sr = ScanResult.new(folder)
				sr.add_file('/mnt/target/file1.txt')
				expect(formatter.files(sr)).to eql ["There is one file", "/mnt/target/file1.txt", "To file"]
			end
		end
		context 'with 3 files' do
			it 'returns the correct number in the string with the files' do
				sr = ScanResult.new(folder)
				sr.add_file('/mnt/target/file1.txt')
				sr.add_file('/mnt/target/file2.txt')
				sr.add_file('/mnt/target/file3.txt')
				expected = ["There are 3 files", "/mnt/target/file1.txt",
								"/mnt/target/file2.txt", "/mnt/target/file3.txt", "To file"]
				expect(formatter.files(sr)).to eql expected
				
			end
		end
		
	end
	
end
