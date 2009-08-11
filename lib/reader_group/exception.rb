module ReaderGroup
  class Exception < StandardError
    def initialize(message = "Sorry: group problem"); super end
  end
  class PermissionDenied < ReaderGroup::Exception
    def initialize(message = "Sorry: you don't have access to that"); super end
  end
end
