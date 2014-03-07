

class Messenger::PushMessenger

	def send_message(msg, devices)
		android = Array.new
		ios = Array.new

		devices.each do |device|
			if device.platform == 'and'
				android.push(device)
			elsif device.platform == 'ios'
				ios.push(device)
			end
		end

		if android.size > 0
			send_android(msg, android)
		end
		if ios.size > 0
			send_ios(msg, ios)
		end
	end

protected
	def send_android(msg, devices)
  	# this is the apiKey obtained from here https://code.google.com/apis/console/
  	#destination = "APA91bFdVQPOCiDVaw50g3fCWYhkArfXgEeY4CDNumk7EGNSIgRDFEOScuGddYi4XIHpo7QGpgGxVtcZ0crl1NVvEpM5omx9A42v6vS9FYjetBGpMYYJw64-AP7VQQsNfKmefvbKXMQTSaeq4bW5iqrZUu-Qi6lltA"
    destination = Array.new
    
    devices.each do |d|
      destination.push(d.token)
    end


    # can be an string or an array of strings containing the regIds of the devices you want to send

    data = {:message => msg, :key2 => ["array", "value"]}
    # must be an hash with all values you want inside you notification

    #GCM.send_notification( destination )
    # Empty notification

    res = GCM.send_notification( destination, data )
    Rails.logger.info("RES #{res}")
    # Notification with custom information

    #GCM.send_notification( destination, data, :collapse_key => "placar_score_global", :time_to_live => 3600, :delay_while_idle => false )
    # Notification with custom information and parameters

  end

	def send_ios(msg, devices)


		
		apn = Houston::Client.development
		apn.certificate = File.read(Rails.configuration.ios_pem)

    destination = Array.new
    
    devices.each do |d|
      # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
      notification = Houston::Notification.new(device: d.token)
      notification.alert = msg

      # Notifications can also change the badge count, have a custom sound, indicate available Newsstand content, or pass along arbitrary data.
      notification.badge = 0
      notification.sound = "sosumi.aiff"
      notification.content_available = true
      
      destination.push(notification)
    end



		

		# And... sent! That's all it takes.
		apn.push(destination)
		

	end

end

