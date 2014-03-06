class RegisterController < ApplicationController
  def android
  	device = Device.where(token: params[:token])

  	if device.nil?
	  	device = Device.new
  		device.token = params[:token]
  		device.type = 'and'
  		device.save
  	end

  	#Return OK
  	respond_to do |format|
    	msg = { :status => "ok"}
    	format.json  { render :json => msg }
  	end
  end

  def ios
  	if device.nil?
	  	device = Device.new
  		device.token = params[:token]
  		device.type = 'ios'
  		device.save
  	end

  	#Return OK
  	respond_to do |format|
    	msg = { :status => "ok"}
    	format.json  { render :json => msg }
  	end
  end
end
