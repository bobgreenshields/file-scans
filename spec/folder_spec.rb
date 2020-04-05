require_relative '../lib/folder'

include FileScans

describe Folder do
	describe '#path' do
		it 'returns a Pathname' do
			fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
			folder = Folder.new(name: 'test', cloudroot: fixture,
													target: fixture + 'target' )
			expect(folder.path).to be_a Pathname
		end
		it 'returns the correct path' do
			fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
			folder = Folder.new(name: 'test', cloudroot: fixture,
													target: fixture + 'target' )
			expect(folder.path.to_s).to eql '/home/bobg/dev/file-scans/fixture/test'
		end
	end
	
end
