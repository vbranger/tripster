class ApplicationMailer < ActionMailer::Base
  default from: 'contact@tripsters.herokuapp.com'
  layout 'mailer'
end
