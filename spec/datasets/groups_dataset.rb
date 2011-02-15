require 'digest/sha1'
class GroupsDataset < Dataset::Base
  datasets = [:pages, :group_readers]
  datasets << :group_sites if defined? Site
  uses *datasets

  def load
    create_group "Normal"
    create_group "Special"
    create_group "Homed", :homepage_id => page_id(:parent)
    create_group "Elsewhere", :site_id => site_id(:elsewhere) if defined? Site

    add_pages_to_group :homed, [:parent, :childless]
    add_readers_to_group :homed, [:normal] 

    add_readers_to_group :special, [:another]
    add_pages_to_group :special, [:news]

    add_readers_to_group :normal, [:normal, :inactive] 
  end
  
  helpers do
    def create_group(name, att={})
      group = create_record Group, name.symbolize, group_attributes(att.update(:name => name))
    end
    
    def group_attributes(att={})
      name = att[:name] || "A group"
      attributes = { 
        :name => name,
        :description => "Test group"
      }.merge(att)
      attributes[:site_id] ||= site_id(:test) if defined? Site
      attributes
    end
  end
  
  def add_pages_to_group(g, pp)
    g = groups(g) unless g.is_a? Group
    pp.each {|p| 
      p = pages(p) unless p.is_a? Page
      p.permit(g)
    }
  end
  
  def add_readers_to_group(g, rr)
    g = groups(g) unless g.is_a? Group
    rr.each {|r| 
      r = readers(r) unless r.is_a? Reader
      g.admit(r)
    }
  end
  
end