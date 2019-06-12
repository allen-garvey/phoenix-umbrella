#creates command to run elixir phoenix json mix task

def datatype_to_ecto(datatype)
	if datatype === :url
		'string'
	elsif datatype === :date
		'utc_datetime'
	elsif datatype === :int
		'integer'
	else
		datatype.to_s
	end
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

mix_command = 'mix phx.gen.json Player Track tracks'


cols.each do |col|
	mix_command = "#{mix_command} #{col[:sql_col]}:#{datatype_to_ecto(col[:datatype])}"
end

puts mix_command