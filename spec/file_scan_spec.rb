require_relative '../lib/file_scan'
# require_relative '../lib/folder'

include FileScans

describe FileScan do
	let(:config) { {'cloudroot' => '/home/bobg/ncfiling',
						 'folders' => [ {'name' => 'inv', 'target' => '/mnt/inv'},
							 {'name' => 'fin', 'target' => '/mnt/fin'} ] } }
	let(:fs) do
			filescan = FileScan.new(config)
			allow(filescan).to receive(:exit_if_dir_not_exist)
			filescan
	end

	describe '#cloudroot' do
		it 'returns a Pathname' do
			expect(fs.cloudroot).to be_a Pathname
		end
		it 'has the correct location' do
			expect(fs.cloudroot.to_s).to eql '/home/bobg/ncfiling'
		end
	end

	describe '#load_folder' do
		it 'returns a Folder' do
			folders = config['folders']
			expect(fs.load_folder(folders[0])).to be_a Folder
		end
		it 'populates the folder with the correct values' do
			folders = config['folders']
			folder = fs.load_folder(folders[0])
			expect(folder.name).to eql 'inv'
			expect(folder.target.to_s).to eql '/mnt/inv'
		end
	end

	describe '#folders' do
		it 'loads the folders' do
			expect(fs.folders.map(&:name)).to eql(['inv', 'fin'])
			expect(fs.folders.map(&:target).map(&:to_s)).to eql(['/mnt/inv', '/mnt/fin'])
		end
		it 'returns the folders enumerator' do
			expect(fs.folders).to be_a Enumerator
			expect(fs.folders.map(&:name)).to eql(['inv', 'fin'])
		end
	end
	
end
