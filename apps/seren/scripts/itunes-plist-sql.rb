#creates sql suitable for elixir phoenix

require 'plist'
require 'uri'

def to_sql_optional_string(s)
	if s.to_s.empty?
		'NULL'
	else
		"'#{s.gsub(/'/, "''")}'"
	end
end

def to_sql_optional_int(d)
	if d.nil?
		'NULL'
	else
		d
	end
end

def url_to_sql_string(url)
	prefix_regex = Regexp.new('^file:///Users/Allen X/Music/iTunes/iTunes Music/')
	to_sql_optional_string(URI.decode(url).gsub(prefix_regex, ''))
end

def to_sql_optional_date(date)
	if date.nil?
		'NULL'
	else
		#with timezone offset 
		# "'#{date.strftime("%Y-%m-%d %H:%M:%S %:z")}'"
		"'#{date.strftime("%Y-%m-%d %H:%M:%S")}'"
	end
end

def to_sql(data, datatype)
	if datatype == :int
		to_sql_optional_int(data)
	elsif datatype == :url
		url_to_sql_string(data)
	elsif datatype == :string
		to_sql_optional_string(data)
	#datetime
	else
		to_sql_optional_date(data)
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

cols << {plist_key: 'Track ID',			sql_col: 'itunes_id',			datatype: :int}
cols << {plist_key: 'Name',				sql_col: 'title',				datatype: :string}
cols << {plist_key: 'Artist',			sql_col: 'artist',				datatype: :string}
cols << {plist_key: 'Genre',			sql_col: 'genre',				datatype: :string}
cols << {plist_key: 'Date Modified',	sql_col: 'date_modified',		datatype: :date}
cols << {plist_key: 'Date Added',		sql_col: 'date_added',			datatype: :date}
cols << {plist_key: 'Kind',				sql_col: 'file_type',			datatype: :string}
cols << {plist_key: 'Size',				sql_col: 'file_size',			datatype: :int}
cols << {plist_key: 'Location',			sql_col: 'file_path',			datatype: :url}
cols << {plist_key: 'Total Time',		sql_col: 'length',				datatype: :int}
cols << {plist_key: 'Bit Rate',			sql_col: 'bit_rate',			datatype: :int}
cols << {plist_key: 'Sample Rate',		sql_col: 'sample_rate',			datatype: :int}
cols << {plist_key: 'Track Number',		sql_col: 'track_number',		datatype: :int}
cols << {plist_key: 'Year',				sql_col: 'relase_year',			datatype: :int}
cols << {plist_key: 'Album',			sql_col: 'album_title',			datatype: :string}
cols << {plist_key: 'Disc Number',		sql_col: 'album_disc_number',	datatype: :int}
cols << {plist_key: 'Disc Count',		sql_col: 'album_disc_count',	datatype: :int}
cols << {plist_key: 'Album Artist',		sql_col: 'album_artist',		datatype: :string}
cols << {plist_key: 'Track Count',		sql_col: 'album_track_count',	datatype: :int}
cols << {plist_key: 'Composer',			sql_col: 'composer',			datatype: :string}
cols << {plist_key: 'Artwork Count',	sql_col: 'artwork_count',		datatype: :int}
cols << {plist_key: 'Play Count',		sql_col: 'play_count',			datatype: :int}
cols << {plist_key: 'Play Date UTC',	sql_col: 'play_date',			datatype: :date}


table_name = 'tracks'

sql_cols = cols.map{|col| col[:sql_col]}.join(', ')

sql_statement_prefix = "INSERT INTO #{table_name}(#{sql_cols}, inserted_at, updated_at) VALUES"


itunes_plist = Plist.parse_xml('/home/allen/Archive/Music/Mac-iTunes/iTunes Music Library.xml')


itunes_plist["Tracks"].each do |track_id, track|
	unless audio_track? track
		next
	end
	sql_values = cols.map{|col| to_sql(track[col[:plist_key]], col[:datatype]) }.join(', ')

	puts "#{sql_statement_prefix} (#{sql_values}, now(), now());"
end