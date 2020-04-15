require_relative '../lib/rc_file'
# require 'yaml'
# require_relative '../lib/scan_result'
# require_relative '../lib/folder'

include FileScans

describe RCFile do
	let(:rcf) do
		result =  RCFile.new('my_rc_file')
		allow(result).to receive(:config_hash).and_return(config)
		result
	end

	describe '#check_for_cloudroot' do
		context 'when there is no cloudroot key' do
			let(:config) { {'this' => 'that' } }
			it 'calls #exit_config_key_missing' do
				expect(rcf).to receive(:exit_config_key_missing).with('cloudroot')
				rcf.check_for_cloudroot
			end
		end
		context 'when there is a cloudroot key' do
			let(:config) { {'this' => 'that', 'cloudroot' => 'new' } }
			it 'does not call #exit_config_key_missing' do
				expect(rcf).not_to receive(:exit_config_key_missing)
				rcf.check_for_cloudroot
			end
		end
	end

	describe '#check_for_folders' do
		context 'when there is no folders key' do
			let(:config) { {'this' => 'that' } }
			it 'calls #exit_config_key_missing' do
				expect(rcf).to receive(:exit_config_key_missing).with('folders')
				rcf.check_for_folders
			end
		end
		context 'when there is a folders key' do
			let(:config) { {'this' => 'that', 'folders' => 'new' } }
			it 'does not call #exit_config_key_missing' do
				expect(rcf).not_to receive(:exit_config_key_missing)
				rcf.check_for_folders
			end
		end
	end

	describe '#check_folders_is_array' do
		context 'when the folders key is not an array' do
			let(:config) { {'this' => 'that', 'folders' => 'new'  } }
			it 'calls #exit_folders_not_array' do
				expect(rcf).to receive(:exit_folders_not_array)
				rcf.check_folders_is_array
			end
		end
		context 'when the folders key is an array' do
			let(:config) { {'this' => 'that', 'folders' => [] } }
			it 'does not call #exit_folders_not_array' do
				expect(rcf).not_to receive(:exit_folders_not_array)
				rcf.check_folders_is_array
			end
		end
	end

	describe '#check_folders_is_array_of_hashes' do
		context 'when the folders key is not an array of hashes' do
			let(:config) { {'this' => 'that', 'folders' => [ {}, 'old']  } }
			it 'calls #exit_folders_not_array_of_hashes' do
				expect(rcf).to receive(:exit_folders_not_array_of_hashes)
				rcf.check_folders_is_array_of_hashes
			end
		end
		context 'when the folders key is an array of_hashes' do
			let(:config) { {'this' => 'that', 'folders' => [ {}, {}] } }
			it 'does not call #exit_folders_not_array_of_hashes' do
				expect(rcf).not_to receive(:exit_folders_not_array_of_hashes)
				rcf.check_folders_is_array_of_hashes
			end
		end
	end

	describe '#check_folder_keys' do
		context 'when the folder hashes do not all contain name and target' do
			let(:config) { {'this' => 'that',
									 'folders' => [ {'name' => 'name', 'target' => 'target'},
									 			 {'name' => 'name', 'not_target' => 'target'}]  } }
			it 'calls #exit_folder_key_missing' do
				expect(rcf).to receive(:exit_folder_key_missing).with('target')
				rcf.check_folder_keys
			end
		end
		context 'when the folder hashes do contain name and target' do
			let(:config) { {'this' => 'that',
									 'folders' => [ {'name' => 'name', 'target' => 'target'},
									 			 {'name' => 'name', 'target' => 'target'}]  } }
			it 'does not call #exit_folder_key_missing' do
				expect(rcf).not_to receive(:exit_folder_key_missing)
				rcf.check_folder_keys
			end
		end
	end

	describe '#read_config_from_file' do
		let(:c_file) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/config.yml' }
		let(:config) { {'this' => 'that' } }
		it 'reads a config file into a hash' do
			expect(rcf.read_config_from_file(c_file)).to be_a Hash
		end
		it 'populates the hash with values' do
			expected = {"cloudroot"=>"home/bobg/dev/file-scans/fixture",
							"folders"=>[
							{"name"=>"builder", "target"=>"home/bobg/dev/file-scans/fixture/target"},
							{"name"=>"inv", "target"=>"home/bobg/dev/file-scans/fixture/target2"}
			]}
			expect(rcf.read_config_from_file(c_file)).to eql(expected)
		end
		context 'when the config file is not correctly formatted' do
			let(:c_file) { Pathname.new(__FILE__).dirname.expand_path + '../fixture/bad_config.yml' }
			it 'exits if the yaml is badly formed' do
				expect(rcf).to receive(:exit_error_loading_yaml)
				result = rcf.read_config_from_file(c_file)
				# expect(result).to eql({})
			end
		end
	end

end
