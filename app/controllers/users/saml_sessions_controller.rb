class Users::SamlSessionsController < Devise::SamlSessionsController

	def new
		request = OneLogin::RubySaml::Authrequest.new()
		action = request.create(saml_config,{'RelayState' => "http://localhost:3000/users/saml/auth"})
		redirect_to action
	end
	def create
		begin
			response = OneLogin::RubySaml::Response.new(params[:SAMLResponse],:settings => saml_config)
			if response.is_valid?
				@user = User.load_saml_data response.attributes
				session[:userid] = response.nameid
				session[:attributes] = response.attributes
				if @user.persisted?
					flash[:notice] = "Signed in successfully."
					sign_in_and_redirect @user, :event => :authentication
		    	end
		  	else
		  		raise "Invalid response"
	  		end
	  	rescue Exception => e
	    	flash[:notice] = e.message
	    	redirect_to root_path
	  	end
	end
	def destroy
	    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
	    flash[:notice] = "Signed out successfully." if signed_out
	    yield if block_given?
		redirect_to "/"
  end

end
