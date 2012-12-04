class MeetingRequestMailer < ActionMailer::Base
  default from: "hello@apprenticehour.com"

  def matched(meeting, message)
    mentee_email = meeting.mentee.email
    mentor_email = meeting.mentor.email
    @meeting = meeting
    @message = message
    mail(:to => mentee_email, :cc => mentor_email, :subject => "ApprenticeHour - You have a matched meeting!")
  end
end
