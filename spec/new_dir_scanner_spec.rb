require_relative '../lib/new_dir_scanner'
require_relative '../lib/scan_result'
require_relative '../lib/folder'

include FileScans

describe NewDirScanner do
	let(:fixture) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/' }
	let(:folder) { folder = Folder.new(name: 'scanner-source', cloudroot: fixture,
													target: fixture + 'scanner-target' ) }
	let(:new_dir_scanner) { NewDirScanner.new(folder) }
	describe '#call' do
		it 'returns a ScanResult' do
			expect(new_dir_scanner.call).to be_a ScanResult
		end
		it 'scans and populates the new dirs in the scanresult' do
			result = new_dir_scanner.call
			expected = ['filing/new2', 'inv/dgs/new']
			new_dirs = result.new_dirs.inject([]) { |array, new_dir| array << new_dir }
			expect(new_dirs).to eql expected
		end

	end

end
