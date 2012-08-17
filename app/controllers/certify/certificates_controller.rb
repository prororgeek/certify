module Certify
  class CertificatesController < ApplicationController

    # GET /certificates/1
    # GET /certificates/1.json
    def show
      @certificate = Certify::Certificate.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @certificate }
      end
    end

    # GET /certificates/new
    # GET /certificates/new.json
    def new
      # get the authority
      @authority = Certify::Authority.find(params[:certify_authority_id])

      # generate a new one
      @certificate = Certify::Certificate.new()

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @certificate }
      end
    end

    # POST /certificates
    # POST /certificates.json
    def create
      # get the ca
      @authority = Certify::Authority.find(params[:certify_authority_id])

      # generate a new one
      @certificate = Certify::Certificate.new(params[:certificate])

      # generate the csr
      if (params[:csr] && params[:csr] != "")
        csr = Certify::Csr.new :data => params[:csr]
      else
        kp = Certify::KeyPair.find(params[:keypair][:id])
        csr = kp.generate_csr('CN=ca/DC=example')
      end

      # sign the csr
      @certificate = @authority.sign_csr(csr)

      # format
      respond_to do |format|
        if @certificate && @certificate.valid?
          format.html { redirect_to certify_authority_path(@authority), notice: 'Certificate was successfully created.' }
          format.json { render json: @certificate, status: :created, location: @certificate }
        else
          format.html { render action: "new" }
          format.json { render json: @certificate.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /certificates/1
    # DELETE /certificates/1.json
    def destroy
      # get the ca
      @authority = Certify::Authority.find(params[:certify_authority_id])

      # get the certificate
      @certificate = Certify::Certificate.find(params[:id])
      @certificate.destroy

      respond_to do |format|
        format.html { redirect_to certify_authority_path(@authority), notice: 'Certificate removed' }
        format.json { head :no_content }
      end
    end


    def download
      # get the ca
      @authority = Certify::Authority.find(params[:certify_authority_id])

      # get the certificate
      @certificate = Certify::Certificate.find(params[:id])

      # respond by specific format
      respond_to do |format|
        format.cer { send_data @certificate.to_pem, :filename => "#{@certificate.uniqueid}.cer", :type => "application/x-x509-ca-cert" }
        format.p12 { send_data @certificate.to_p12!(:password => params[:password], :display => params[:display]).to_der, :filename => "#{@certificate.uniqueid}.p12", :type => "application/x-x509-ca-cert" }
      end
    end
  end
end
