class Tweet
  attr_reader :id, :author, :message, :profile_image_url
  attr_accessor :profile_image

  def initialize(dict)
    @id = dict['id']
    @author = dict['from_user_name']
    @message = dict['text']
    @profile_image_url = dict['profile_image_url']
    @profile_image = nil
  end
end
