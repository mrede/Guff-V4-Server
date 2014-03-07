class MessageController < ApplicationController

	protect_from_forgery except: :post

  def get
  	logger.info("Get called #{params[:latitude]}, #{params[:longitude]}")

  	# set message cut off
  	expiry = Time.now - 7200

  	expiry = Time.now - 1.hour

  	messages = ActiveRecord::Base.connection.execute("select id, distance, message, latitude, longitude, created_at from ( select ( 6371 * acos( cos( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * cos( radians( a.latitude ) ) * cos( radians( a.longitude ) - radians(#{params[:longitude]}.#{params[:lon_dec]}) ) + sin( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * sin( radians( a.latitude ) ) ) ) as distance, a.* from messages a ) as dt where distance < 0.2 and created_at > '#{expiry.strftime('%Y-%m-%d %H:%M:%S')}' order by created_at desc")

  	logger.info("MESSAGES: #{messages.size}")
  	messages.each do |m|
  		logger.info("N: #{m}")
  	end

  end

  def post
  	

  	msg = Message.new
  	msg.message = params[:message]
  	msg.accuracy = params[:accuracy]
  	msg.latitude = params[:latitude]
  	msg.longitude = params[:longitude]
  	msg.device_id = Device.where(token: params[:token]).first
  	msg.ip = request.remote_ip

  	if msg.save
	    output = { :status => "ok"}
    else
	    output = { :status => "err"}
    end

    respond_to do |format|
    	format.json  { render :json => output }
  	end

  end
end
