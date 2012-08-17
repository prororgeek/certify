class Certify::KeyPairsController < ApplicationController

  # GET /certify/private_keys/1
  # GET /certify/private_keys/1.json
  def show
    # get the authority
    @authority = Certify::Authority.find(params[:certify_authority_id])
    @keypair = @authority.key_pairs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @keypair }
    end
  end

  # GET /certify/private_keys/new
  # GET /certify/private_keys/new.json
  def new
    # get the authority
    @authority = Certify::Authority.find(params[:certify_authority_id])
    @keypair = @authority.key_pairs.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @keypair }
    end
  end

  # POST /certify/private_keys
  # POST /certify/private_keys.json
  def create
    # get the ca
    @authority = Certify::Authority.find(params[:certify_authority_id])

    @keypair = Certify::KeyPair.new(params[:keypair])
    @keypair.authority = @authority

    respond_to do |format|
      if @keypair.save
        format.html { redirect_to certify_authority_path(@authority), notice: 'Private key was successfully created.' }
        format.json { render json: @keypair, status: :created, location: @keypair }
      else
        format.html { render action: "new" }
        format.json { render json: @keypair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /certify/private_keys/1
  # DELETE /certify/private_keys/1.json
  def destroy
    @authority = Certify::Authority.find(params[:certify_authority_id])
    @keypair = @authority.key_pairs.find(params[:id])
    @keypair.destroy

    respond_to do |format|
      format.html { redirect_to certify_authority_path(@authority), notice: 'Private key was successfully removed.'  }
      format.json { head :no_content }
    end
  end

  def download
    # get the ca
    @authority = Certify::Authority.find(params[:certify_authority_id])

    # get the certificate
    @keypair = Certify::KeyPair.find(params[:id])

    # respond by specific format
    respond_to do |format|
      format.pem { send_data @keypair.to_pem, :filename => "#{@keypair.uniqueid}.key.pem", :type => "application/x-x509-ca-cert" }
    end
  end
end
