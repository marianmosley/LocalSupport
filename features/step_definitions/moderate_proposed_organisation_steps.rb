Then (/^I should( not)? see an "Accept Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_button "Accept"
  else
      expect(page).to have_button "Accept"
  end
end
Then (/^I should( not)? see a "Reject Proposed Organisation" button$/) do |negation|
  if negation
    expect(page).not_to have_link "Reject"
  else
    expect(page).to have_link "Reject"
  end
end

Then(/^I click on the all proposed organisations link$/) do
  click_link "All Proposed Organisations"
end

Then(/^I should be on the show page for the organisation that was proposed$/) do
  steps %{Then I should be on the show page for the organisation named "#{unsaved_proposed_organisation.name}"}
end