class StaticPagesController < ApplicationController
  def home
    return if params[:collection_id].blank?

    @collection_id = params[:collection_id].strip
    @photos = PexelsClient.new.collection_photos(@collection_id)
  rescue PexelsClient::Error => e
    @error_message = e.message
    @photos = []
  end
end
