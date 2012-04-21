module Certify
  class CertificatesController < ApplicationController

    # GET /certificates/1
    # GET /certificates/1.json
    def show
      @certificate = Certificate.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @certificate }
      end
    end
  
    # GET /certificates/new
    # GET /certificates/new.json
    def new
      # get the authority
      @authority = Authority.find(params[:certify_authority_id])

      # generate a new one
      @certificate = Certificate.new()

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @certificate }
      end
    end

    # POST /certificates
    # POST /certificates.json
    def create
      # get the ca
      @authority = Authority.find(params[:certify_authority_id])

      # create the cert
      @certificate = @authority.certificates.build()

      # apply the csr
      @certificate.csr=params[:csr]

      # format
      respond_to do |format|
        if @certificate.save
          format.html { redirect_to authority_path(@authority), notice: 'Certificate was successfully created.' }
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
      @authority = Authority.find(params[:certify_authority_id])

      # get the certificate
      @certificate = Certificate.find(params[:id])
      @certificate.destroy
  
      respond_to do |format|
        format.html { redirect_to authority_path(@authority), notice: 'Certificate removed' }
        format.json { head :no_content }
      end
    end
  end
end
