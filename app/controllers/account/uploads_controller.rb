# frozen_string_literal: true

module Account
  #:nodoc:
  class UploadsController < BaseController
    include ApplicationHelper
    before_action :set_business, only: %i[create remove_image]

    def create
      if params[:business].present?
        file_name = params[:business][:gallery].original_filename
        if @business.gallery.attach(params[:business][:gallery])
          # send success header
          render json: { message: 'success', fileName: file_name }, status: :ok
         end
      else
        render json: { error: @business.errors.full_messages.join(',') }, status: :bad_request
      end
    end

    private

    def set_business
      if current_user.present?
        @business = current_user.businesses.find_by(id: params[:id])
      end
      if current_partner.present?
        @business = current_partner.businesses.find_by(id: params[:id])
      end
      if current_partners_partner_user.present?
        @business = current_partners_partner_user.businesses.find_by(id: params[:id])
      end
    end

    def set_image_blob
      @image = ActiveStorage::Blob.find_by_key(params[:key])
      render json: { message: 'Image Not Found!!!!!' } if @image.blank?
    end
  end
end
