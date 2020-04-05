require_relative '../lib/dir_builder'
require_relative '../lib/folder'
require 'pathname'

include FileScans

describe DirBuilder do
	it 'builds a dir structure' do
		fixture = Pathname.new(__FILE__).dirname.expand_path + '../fixture/'
		builder_dir = fixture + 'builder'
		builder_dir.rmtree if builder_dir.exist?
		folder = Folder.new(name: 'builder', cloudroot: fixture, target: fixture + 'target' )
		builder = DirBuilder.new(folder)
		builder.call
		expect(builder_dir.exist?).to be_truthy
		dirs = %w(filing/car filing/house inv/dgs inv/fpl inv/fpl/houses)
		dirs.each do | dir |
			expect((builder_dir + dir).directory?).to be_truthy
		end
		
	end
	
end
