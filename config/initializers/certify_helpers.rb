#
# this handler generates a new unique id
def generate_unique_id
  if self.uniqueid.nil?
    self.uniqueid = UUIDTools::UUID.random_create().to_s
  end
end