require 'plist'


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



itunes_plist = Plist.parse_xml('/home/allen/Archive/Music/Mac-iTunes/iTunes Music Library.xml')

track_fields = Hash.new

itunes_plist["Tracks"].each do |track_id, track|
	unless audio_track? track
		next
	end
	track.each do |key, value|
		if !track_fields.include? key
			track_fields[key] = {type: value.class.to_s, count: 1}
		else
			track_fields[key][:count] = track_fields[key][:count] + 1
		end
	end
end

#csv output
# puts "Field,Type,Count"
# track_fields.each do |field_name, info|
# 	puts "#{field_name},#{info[:type]},#{info[:count]}"
# end


# see contents of a single key
itunes_plist["Tracks"].each do |track_id, track|
	# track_type = track["Track Type"]
	# unless track_type == "File"
	# 	puts "#{track_type} #{track["Name"]}"
	# end
	key = ""
	if track.include? key
		puts "#{track["Artist"]}\t#{track["Name"]}\t#{track[key]}"
	end
end



#for location
#require 'uri'
#puts URI.decode(track["Location"])