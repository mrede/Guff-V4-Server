class MessageController < ApplicationController

	protect_from_forgery except: :post

  def get
  	logger.info("Get called #{params[:latitude]}, #{params[:longitude]}")

  	# set message cut off
  	expiry = Time.now - 2.hours

  	messages = ActiveRecord::Base.connection.execute("select distance, message, created_at from ( select ( 6371 * acos( cos( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * cos( radians( a.latitude ) ) * cos( radians( a.longitude ) - radians(#{params[:longitude]}.#{params[:lon_dec]}) ) + sin( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * sin( radians( a.latitude ) ) ) ) as distance, a.* from messages a ) as dt where distance < 0.2 and created_at > '#{expiry.strftime('%Y-%m-%d %H:%M:%S')}' order by created_at desc")

  	logger.info("MESSAGES: #{messages.size}")

  	output = Array.new
  	messages.each do |m|
  		logger.info("M: #{m}")
  		h = Hash.new
  		h['m'] = m[1]
  		h['d'] = m[0]
  		h['t'] = 7200 - ((Time.now ) - m[2])
  		output.push(h)
  	end

  	respond_to do |format|
    	format.json  { render :json => output }
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
