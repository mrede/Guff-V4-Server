class MessageController < ApplicationController

	protect_from_forgery except: :post

  def get
  	logger.info("Get called #{params[:latitude]}, #{params[:longitude]}")

  	# get out device
  	device = Device.where(token: params[:token]).first

  	record_location(device)

  	# set message cut off
  	expiry = Time.now - 2.hours

  	output = get_local_messages(expiry)



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

  	# get out device
  	device = Device.where(token: params[:token]).first


  	# set message cut off
  	expiry = Time.now - 2.hours
  	local_devices = get_local_devices(expiry, device)

  	pm = Messenger::PushMessenger.new
  	pm.send_message(msg.message, local_devices)


  	if msg.save
	    output = { :status => "ok"}
    else
	    output = { :status => "err"}
    end

    respond_to do |format|
    	format.json  { render :json => output }
  	end

  end

protected 

	def get_local_messages(expiry)
		messages = ActiveRecord::Base.connection.execute("select distance, message, created_at from ( select ( 6371 * acos( cos( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * cos( radians( a.latitude ) ) * cos( radians( a.longitude ) - radians(#{params[:longitude]}.#{params[:lon_dec]}) ) + sin( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * sin( radians( a.latitude ) ) ) ) as distance, a.* from messages a ) as dt where distance < 0.2 and created_at > '#{expiry.strftime('%Y-%m-%d %H:%M:%S')}' order by created_at desc")

  	output = Array.new
  	messages.each do |m|
  		logger.info("M: #{m}")
  		h = Hash.new
  		h['m'] = m[1]
  		h['d'] = m[0]
  		h['t'] = 7200 - ((Time.now ) - m[2])
  		output.push(h)
  	end

  	output
  end

  def get_local_devices(expiry, device)
		devices_ids = ActiveRecord::Base.connection.execute("select device_id from ( select ( 6371 * acos( cos( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * cos( radians( a.latitude ) ) * cos( radians( a.longitude ) - radians(#{params[:longitude]}.#{params[:lon_dec]}) ) + sin( radians(#{params[:latitude]}.#{params[:lat_dec]}) ) * sin( radians( a.latitude ) ) ) ) as distance, a.* from locations a ) as dt where distance < 0.2 and created_at > '#{expiry.strftime('%Y-%m-%d %H:%M:%S')}' and device_id <> #{device.id} order by created_at desc")
		logger.info("DEVICES IN AREA #{devices_ids.to_a}")

		devices = Array.new

		devices_ids.each do |d|
			dev = Device.find_by_id(d)
			logger.info("DEvice token: #{dev.token}")
			devices.push(dev)
		end

		devices
	end

	def record_location(device)

		if device.location.nil?
			logger.info("No location")
			device.location = Location.new
		end

		device.location.latitude = "#{params[:latitude]}.#{params[:lat_dec]}"
		device.location.longitude = longitude
		device.location.save
	end

	def latitude
		"#{params[:latitude]}.#{params[:lat_dec]}"
	end

	def longitude
		"#{params[:longitude]}.#{params[:lon_dec]}"
	end

end
