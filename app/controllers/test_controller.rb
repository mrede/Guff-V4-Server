class TestController < ApplicationController
  def send_message

  	msg = params[:msg]
  	send_android(msg)
    send_ios(msg)
  	


  end

  def register
  	logger.info("Registration #{params[:id]}")
  end


protected
  def send_android(msg)
  	# this is the apiKey obtained from here https://code.google.com/apis/console/
  	destination = "APA91bFdVQPOCiDVaw50g3fCWYhkArfXgEeY4CDNumk7EGNSIgRDFEOScuGddYi4XIHpo7QGpgGxVtcZ0crl1NVvEpM5omx9A42v6vS9FYjetBGpMYYJw64-AP7VQQsNfKmefvbKXMQTSaeq4bW5iqrZUu-Qi6lltA"
    # can be an string or an array of strings containing the regIds of the devices you want to send

    data = {:message => msg, :key2 => ["array", "value"]}
    # must be an hash with all values you want inside you notification

    #GCM.send_notification( destination )
    # Empty notification

    res = GCM.send_notification( destination, data )
    logger.info("RES #{res}")
    # Notification with custom information

    #GCM.send_notification( destination, data, :collapse_key => "placar_score_global", :time_to_live => 3600, :delay_while_idle => false )
    # Notification with custom information and parameters

  end

	def send_ios(msg)


		
		apn = Houston::Client.development
		apn.certificate = File.read('/Users/ben/Sites/Label/LabelPusher/lib/joint.pem')

		# An example of the token sent back when a device registers for notifications
		token = "45884a5865c8faf4ef815ceeeace8ebf734c20ae6e3299e4853786aed3842463"

		# Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
		notification = Houston::Notification.new(device: token)
		notification.alert = msg

		# Notifications can also change the badge count, have a custom sound, indicate available Newsstand content, or pass along arbitrary data.
		notification.badge = 0
		notification.sound = "sosumi.aiff"
		notification.content_available = true
		#notification.custom_data = {foo: "bar"}

		# And... sent! That's all it takes.
		apn.push(notification)
		

	end

end
