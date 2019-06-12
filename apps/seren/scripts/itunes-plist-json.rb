require 'json/ext'
require 'plist'
require 'uri'


def url_to_json(url)
	prefix_regex = Regexp.new('^file:///Users/Allen X/Music/iTunes/iTunes Music/')
	URI.decode(url).gsub(prefix_regex, '')
end

def to_json_optional_date(date)
	if date.nil?
		nil
	else
		#with timezone offset 
		#date.strftime("%Y-%m-%d %H:%M:%S %:z")
		date.strftime("%Y-%m-%d %H:%M:%S")
	end
end

def to_json(data, datatype)
	if datatype == :date
		to_json_optional_date(data)
	elsif datatype == :url
		url_to_json(data)
	else
		data
	end
end


def audio_track?(track)
	unless track["Kind"].include? " audio "
		return false
	end
	unless track["Track Type"] == "File"
		return false
	end
	unless track.include?("Movie") and track["Movie"] == true
		false
	end
	unless track.include?("TV Show") and track["TV Show"] == true
		false
	end
	true
end




cols = []

cols << {plist_key: 'Track ID',			json_key: 'id',					datatype: :int}
cols << {plist_key: 'Name',				json_key: 'title',				datatype: :string}
cols << {plist_key: 'Artist',			json_key: 'artist',				datatype: :string}
cols << {plist_key: 'Genre',			json_key: 'genre',				datatype: :string}
cols << {plist_key: 'Date Added',		json_key: 'date_added',			datatype: :date}
cols << {plist_key: 'Kind',				json_key: 'file_type',			datatype: :string}
cols << {plist_key: 'Size',				json_key: 'file_size',			datatype: :int}
cols << {plist_key: 'Location',			json_key: 'file_path',			datatype: :url}
cols << {plist_key: 'Total Time',		json_key: 'length',				datatype: :int}
cols << {plist_key: 'Bit Rate',			json_key: 'bit_rate',			datatype: :int}
cols << {plist_key: 'Track Number',		json_key: 'track_number',		datatype: :int}
cols << {plist_key: 'Album',			json_key: 'album_title',		datatype: :string}
cols << {plist_key: 'Composer',			json_key: 'composer',			datatype: :string}
cols << {plist_key: 'Artwork Count',	json_key: 'artwork_count',		datatype: :int}
cols << {plist_key: 'Play Count',		json_key: 'play_count',			datatype: :int}


data = []

itunes_plist = Plist.parse_xml('/home/allen/Archive/Music/Mac-iTunes/iTunes Music Library.xml')


itunes_plist["Tracks"].each do |track_id, track|
	unless audio_track? track
		next
	end

	track_json = Hash.new

	cols.each do |col|
		json_value = to_json(track[col[:plist_key]], col[:datatype])
		unless json_value.nil?
			track_json[col[:json_key]] = json_value
		end
	end

	data << track_json

end


json = {data: data}

puts json.to_json