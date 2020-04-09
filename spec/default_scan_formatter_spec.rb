require_relative '../lib/scan_result'
require_relative '../lib/default_scan_formatter'
require_relative '../lib/folder'

include FileScans

describe DefaultScanFormatter do
	describe '#files' do
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

	describe '#new_dirs' do
		let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
		let(:folder) do
			Folder.new(name: 'test', cloudroot: fixture, target: fixture + 'target' )
		end
		let(:formatter) { DefaultScanFormatter.new }
		context 'with no new dir' do
			it 'returns an array with the correct string' do
				sr = ScanResult.new(folder)
				expect(formatter.new_dirs(sr)).to eql ["There are no new dirs to create"]
			end
		end
		context 'with one new dir' do
			it 'returns the single new dir string and the new dir name' do
				sr = ScanResult.new(folder)
				sr.add_new_dir('/mnt/target/new_dir')
				expect(formatter.new_dirs(sr)).to eql ["There is one new dir", "/mnt/target/new_dir", "To create"]
			end
		end
		context 'with 3 new dirs' do
			it 'returns the correct number in the string with the new dirs' do
				sr = ScanResult.new(folder)
				sr.add_new_dir('/mnt/target/new_dir1')
				sr.add_new_dir('/mnt/target/new_dir2')
				sr.add_new_dir('/mnt/target/new_dir3')
				expected = ["There are 3 new dirs", "/mnt/target/new_dir1",
								"/mnt/target/new_dir2", "/mnt/target/new_dir3", "To create"]
				expect(formatter.new_dirs(sr)).to eql expected
			end
		end
	end

	end

end
