require File.dirname(__FILE__) + '/../test_helper'

class AbuseComplaintTest < ActiveSupport::TestCase

  should 'be related with a reported' do
    reported = fast_create(Profile)
    abuse_complaint = AbuseComplaint.new

    assert !abuse_complaint.valid?
    assert abuse_complaint.errors.invalid?(:reported)

    abuse_complaint.reported = reported

    assert abuse_complaint.valid?
  end

  should 'become active if number of reports passes environment\'s lower bound' do
    reported = fast_create(Profile)
    p1 = fast_create(Person)
    p2 = fast_create(Person)
    p3 = fast_create(Person)
    abuse_complaint = AbuseComplaint.create!(:reported => reported)

    assert_equal Task::Status::HIDDEN, abuse_complaint.status

    reported.environment.stubs(:reports_lower_bound).returns(2)
    r1 = AbuseReport.create!(:reporter => p1, :abuse_complaint => abuse_complaint, :reason => 'some reason')
    r2 = AbuseReport.create!(:reporter => p2, :abuse_complaint => abuse_complaint, :reason => 'some reason')
    r3 = AbuseReport.create!(:reporter => p3, :abuse_complaint => abuse_complaint, :reason => 'some reason')

    assert_equal Task::Status::ACTIVE, abuse_complaint.status
  end

  should 'start with hidden status' do
    t = AbuseComplaint.create
    assert_equal Task::Status::HIDDEN, t.status
  end

  should 'be destroyed with reported' do
    reported = fast_create(Profile)
    reported_id = reported.id
    abuse_complaint = AbuseComplaint.create!(:reported => reported)

    assert AbuseComplaint.find_by_requestor_id(reported_id), "AbuseComplaint was not created!"

    reported.destroy

    assert !AbuseComplaint.find_by_requestor_id(reported_id), "AbuseComplaint still exist!"
  end
end
