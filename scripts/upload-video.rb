#!ruby
# 
# Takes a presentation serialized as YAML from STDIN for which a video has
# already been generated and uploads it to YouTube.
# 
# TODO:
#  - check whether a video with that same title has already been uploaded, and
#    by default don't overwrite
#  - add command line switch which allows overwriting existing videos
#  - record the YouTube ID from the upload and add it to the presentation object
#  - handle errors that may occur during the upload and add relevent information
#    to the presentation object.
#  - gracefully handle missing configuration env variables
# 
# NOTES:
#  - having a helluva time figuring out how to query the YouTube client for 
#    videos matching an exact video title.  feel like this is getting close:
#    client.videos_by(
#      :user => 'viddictionary',
#      :per_page => 1,
#      :fields => {
#        :entry => 'title="work - definition"'
#      })

require 'yaml'
require 'youtube_it'

require './scripts/common.rb'

# upload a video given a client connection and a presentation data object
def upload_video(client, presentation)
  slides = presentation['slides']
  term = presentation['term']
  definition = presentation['definition']
  video = client.video_upload(
    File.open(presentation['video']),
    :title => "#{term} - definition",
    :description => definition,
    :keywords => [term, 'definition'])
  presentation['youtube_video'] = video
  presentation['youtube_id'] = video.unique_id.to_s
  video
end

client = YouTubeIt::Client.new(
  :username => ENV['YOUTUBE_UN'],
  :password => ENV['YOUTUBE_PW'],
  :dev_key => ENV['YOUTUBE_DK'])

presentation = YAML::load(STDIN.read)
upload_video(client, presentation)

puts presentation.to_yaml
