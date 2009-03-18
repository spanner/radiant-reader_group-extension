require 'digest/sha1'
class GroupReadersDataset < Dataset::Base
  uses :group_sites if defined? Site

  def load
    create_reader "Normal"
    create_reader "Another"
    create_reader "Ungrouped"
    create_reader "Inactive", :activated_at => nil, :activation_code => 'randomstring'
    create_reader "Elsewhere", :site_id => site_id(:elsewhere) if defined? Site
  end
  
  helpers do
    def create_reader(name, attributes={})
      attributes = reader_attributes(attributes.update(:name => name))
      reader = create_record Reader, name.symbolize, attributes
    end
    
    def reader_attributes(attributes={})
      name = attributes[:name] || "John Doe"
      symbol = name.symbolize
      attributes = { 
        :name => name,
        :email => "#{symbol}@spanner.org", 
        :login => "#{symbol}@spanner.org", 
        :salt => "golly",
        :password => Digest::SHA1.hexdigest("--golly--password--"),
        :activation_code => nil,
        :activated_at => Time.now.utc
      }.merge(attributes)
      attributes[:site_id] ||= site_id(:test) if defined? Site
      attributes
    end
    
    def login_as_reader(reader)
      login_reader = reader.is_a?(Reader) ? reader : readers(reader)
      request.session['reader_id'] = login_reader.id
      login_reader
    end
    
    def logout_reader
      request.session['reader_id'] = nil
    end
  end
 
end