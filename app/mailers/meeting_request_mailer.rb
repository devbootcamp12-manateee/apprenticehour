class MeetingRequestMailer < ActionMailer::Base
  default from: "hello@apprenticehour.com"

  def matched(meeting)
    mentee_email = meeting.mentee.email
    mentor_email = meeting.mentor.email
    @meeting = meeting
    mail(:to => mentee_email, :cc => mentor_email, :subject => "Welcome to My Awesome Site: MENTEE")
  end
end
