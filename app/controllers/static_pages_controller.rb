class StaticPagesController < ApplicationController
  def home
    return if params[:collection_id].blank?

    @collection_id = params[:collection_id].strip
    @photos = PexelsClient.new.collection_photos(@collection_id)

    if @photos.empty?
      @error_message = "No photos were found for that collection"
    end
  rescue PexelsClient::Error => e
    @error_message = e.message
    @photos = []
  end
end
