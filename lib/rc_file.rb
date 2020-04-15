require 'pathname'
require 'yaml'

module FileScans
	class RCFile
		def initialize(rcfile)
			@path = Pathname.new(rcfile)
		end

		def config_hash
			@config_hash ||= read_config_from_file(@path)
		end

		def call
			check_for_cloudroot
			check_for_folders
			check_folders_is_array
			check_folders_is_array_of_hashes
			check_folder_keys
			config_hash
		end

		def read_config_from_file(path)
			exit_rc_not_exist unless path.exist?
			begin
				result = YAML.load(path.read)
				exit_error_loading_yaml("The file returned nil from the yaml") if result.nil?
				result
			rescue StandardError => e
				exit_error_loading_yaml(e.message)
			end
			# {"hi" => "bob"}
		end

		def check_for_cloudroot
			exit_config_key_missing('cloudroot') unless config_hash.key?('cloudroot')
		end

		def check_for_folders
			exit_config_key_missing('folders') unless config_hash.key?('folders')
		end

		def check_folders_is_array
			exit_folders_not_array unless config_hash['folders'].is_a?(Array)
		end

		def check_folders_is_array_of_hashes
			not_hashes = config_hash['folders'].reject { |item| item.is_a? Hash }
			exit_folders_not_array_of_hashes unless not_hashes.empty?
		end

		def check_folder_keys
			config_hash['folders'].each do |folder_hash|
				%w(name target).each do |key|
					exit_folder_key_missing(key) unless folder_hash.key?(key)
				end
			end
		end

		def exit_rc_not_exist
			STDERR.puts "Was expecting to find a config file called #{@path.basename}"
			STDERR.puts "at #{@path}"
			STDERR.puts "but one could not be found"
			exit(65)
		end

		def exit_error_loading_yaml(message)
				STDERR.puts "There was a problem loading the config file"
				STDERR.puts @path.to_s
				STDERR.puts "It should be formatted in YAML"
				STDERR.puts error.message
				exit(66)
		end

		def exit_config_key_missing(key)
			STDERR.puts "Looking in the config file for a key called #{key}"
			STDERR.puts "but none could be found"
			exit(67)
		end

		def exit_folders_not_array
			STDERR.puts "The folders key in the config hash needs to be an array"
			exit(68)
		end

		def exit_folders_not_array_of_hashes
			STDERR.puts "Each item in the folders array should be a hash and some weren't"
			exit(69)
		end

		def exit_folder_key_missing(key)
			STDERR.puts "Looking in the folder info for a key called #{key}"
			STDERR.puts "but none could be found"
			exit(70)
		end

	end
end
