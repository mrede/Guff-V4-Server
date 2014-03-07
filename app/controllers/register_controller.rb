class RegisterController < ApplicationController
  def android
  	device = Device.where(token: params[:token], platform: 'and').first

  	if device.nil?
	  	device = Device.new
  		device.token = params[:token]
  		device.platform = 'and'
  		device.save
  	end

  	#Return OK
  	respond_to do |format|
    	msg = { :status => "ok"}
    	format.json  { render :json => msg }
  	end
  end

  def ios
  	device = Device.where(token: params[:token], platform: 'ios').first
  	if device.nil?
	  	device = Device.new
  		device.token = params[:token]
  		device.platform = 'ios'
  		device.save
  	end

  	#Return OK
  	respond_to do |format|
    	msg = { :status => "ok"}
    	format.json  { render :json => msg }
  	end
  end
end
