require "authlogic/test_case"

class GroupMessagesDataset < Dataset::Base
  datasets = [:groups]
  datasets << :group_sites if defined? Site
  uses *datasets

  def load
    create_message "Normal"
    create_message "Grouped", :group => groups(:normal)
  end

  helpers do
    def create_message(subject, attributes={})
      attributes = message_attributes(attributes.update(:subject => subject))
      message = create_model Message, subject.symbolize, attributes
    end

    def message_attributes(attributes={})
      subject = attributes[:subject] || "Message"
      symbol = subject.symbolize
      attributes = { 
        :subject => subject,
        :body => "This is the #{subject} message"
      }.merge(attributes)
      attributes[:site] = sites(:test) if defined? Site
      attributes
    end

  end
 
end