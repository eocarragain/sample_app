include ApplicationHelper

#authentication
def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end


RSpec::Matchers.define :have_success_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-success', text: message)
  end
end


RSpec::Matchers.define :have_signedin_user_profile_info do |user|
  match do |page|

      page { should have_title(user.name) }
      page { should have_link('Users',       href: users_path) }
      page { should have_link('Settings',    href: edit_user_path(user)) }
      page { should have_link('Profile',     href: user_path(user)) }
      page { should have_link('Sign out',    href: signout_path) }
      page { should_not have_link('Sign in', href: signin_path) }
  end
end
