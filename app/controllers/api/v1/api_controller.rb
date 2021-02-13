module Api
  module V1
    class ApiController < ApplicationController
        skip_before_action :verify_authenticity_token
    	# before_action :authenticate_user!, only: [:upload_video, :toggle_file_favourite, :get_user_favourites]

    	def get_current_user   		
    		# current_user
    		User.first
    	end

        def get_files
            return_object = []
            file_type = params[:file_type]
            files = Upload.where(type:params[:file_type]).paginate(page: params[:page], per_page:2)
            files.collect { |i_file|
                result = {
                  id: i_file.id,
                  title: i_file.title,
                  description: i_file.description,
                  owner_name: i_file.user.name,
                  attachment_url: polymorphic_url(i_file.attachment)
                }
                if i_file.user.profile_photo.attached?
                    # polymorphic_url  = polymorphic_url(i_file.user.profile_photo)
                    result[:owner_profile_photo_url] = polymorphic_url(i_file.user.profile_photo)
                end
                return_object << result
            }
          create_response(return_object,200)
        end

        def get_file_details
            unless params[:file_id].blank?
                file = Upload.where(params[:file_id]).last
                unless file.blank?
                    result_object = {
                        id: file.id,
                        title: file.title,
                        description: file.description,
                        owner_name: file.user.name,
                        attachment_url: polymorphic_url(file.attachment)
                    }
                    if file.user.profile_photo.attached?
                        polymorphic_url  = polymorphic_url(file.user.profile_photo)
                        result_object[:owner_profile_photo_url] = polymorphic_url
                    end
                    message, code = [result_object, 200]
                else
                    message, code = ["Image/Video not found", 404]
                end
            else
                message, code = ["File id not found", 400]
            end  
            create_response(message,200)  
        end

    	def upload_files
    		title = upload_params[:title]
    		description = upload_params[:description]
    		attachment = upload_params[:attachment]
            file_type = upload_params[:file_type]
    		unless title.blank? || description.blank? || attachment.blank? || file_type.blank?
    			new_upload = {
    				title: title,
    				description: description,
                    type: file_type,
                    attachment: attachment,
    			}
                current_user = get_current_user
    			current_user.uploads.create(new_upload)
                # current_user.videos.attachment.attach(attachment)
    			message, code = ["Uploaded successfully!!", 200]
    		else
    			message, code = ["Error!!", 400]
    		end
    		create_response( message,code)
    	end

        def search_files
            page = params[:page].present? ? params[:page].to_i : 1
            per_page = 20
            starting_offset = 0
            offset = starting_offset + ((page - 1) * per_page)
            search_key = params[:search_key].present? ? params[:search_key] : nil
            result = if search_key
               # Upload.search(search_key)
               Upload.search search_key, page: page, per_page: per_page, offset: offset
            else
               Upload.all
            end
            create_response(result,200)
        end

        def toggle_file_favourite
            current_user = get_current_user
            current_user_id = current_user.id
            file_id = params[:file_id]
            unless params[:file_id].blank?
                file = Upload.where(params[:file_id]).last
                user_favourites = Favourite.where(user_id:current_user_id,upload_id:params[:file_id]).last
                if user_favourites.present?
                    user_favourites.destroy
                    message,code = ["Successfully deleted favourite", 200]
                else
                    current_user.favourites.create(upload_id:params[:file_id])  
                    message,code = ["Successfully added favourite", 200]
                end
            else
                message, code = ["File id not found", 400]
            end  
            create_response(message,200)  

        end

        def get_user_favourites
           current_user = get_current_user 
           user_favourites = current_user.favourites
           upload_ids = user_favourites.pluck(:upload_id)
           return_object = []
           favourites = Upload.where(id:upload_ids)
           favourites.collect { |i_file|
                result = {
                  id: i_file.id,
                  title: i_file.title,
                  description: i_file.description,
                  type: i_file.type,
                  owner_name: i_file.user.name,
                  attachment_url: polymorphic_url(i_file.attachment)
                }
                if i_file.user.profile_photo.attached?
                    polymorphic_url  = polymorphic_url(i_file.user.profile_photo)
                    result[:owner_profile_photo_url] = polymorphic_url
                end
                return_object << result
            }
           create_response(return_object,200)  
        end

        def get_trending_image
            image_ids = Image.ids
            trending_image_id = image_ids.sample
            image = Image.where(id:trending_image_id).last
            return_object = {
                        id: image.id,
                        title: image.title,
                        description: image.description,
                        owner_name: image.user.name,
                        attachment_url: polymorphic_url(image.attachment)
                    }
            if image.user.profile_photo.attached?
                polymorphic_url  = polymorphic_url(image.user.profile_photo)
                return_object[:owner_profile_photo_url] = polymorphic_url
            end
            create_response(return_object,200)  
        end

      
	  private

	  	def upload_params
	  		params.permit(:title, :description, :attachment, :file_type)
	  	end

		def create_response( result_data,status)
		  result = (200..299).include?(status) ? 1 : 0
		  if result == 1
		    render :json => {result_status: result, result_data: result_data}, status: status and return
		  else
		    error = {:error_code => status, :error_message => result_data}
		    render :json => {result_status: result, result_data: error}, status: status and return
		  end
		end
    end
  end
end