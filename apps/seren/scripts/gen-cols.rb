#generates ruby list of hashes used as cols for other scripts

data = <<-eos
Track ID
Size
Date Modified
Date Added
Name
Kind
Location
Total Time
Artist
Bit Rate
Sample Rate
Album
Track Number
Genre
Year
Disc Number
Disc Count
Album Artist
Composer
Track Count
Artwork Count
Play Count
Play Date UTC
eos

data.split("\n").each do |line|
	puts "rows << {plist_key: '#{line}',\t\t\t\tsql_col: '#{line}',\tdatatype: :string}"
end