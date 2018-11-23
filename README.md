# #NoRegrets

Adding visual regression testing to your Capybara specs

## Getting started

NoRegrets allows you to automate screenshot checking from Capybara specs. This means you need to have a test suite with Capybara, and a Capybara driver that allows taking screenshots (I recommend chrome-headless).

Let's assume you already have a feature spec that looks something like this:
```
require "rails_helper"

RSpec.describe "Homepage", js: true do
  it "load the homepage properly" do
    visit "/"
    expect(page).to have_content "Welcome to my awesome site!"
  end
end
```

It's nice to check that your tagline is on the page, but it would be lovely to be able to tell when the look of the page changes, in case an unsuspicious-looking tweak to your css broke down your page. Let's set that up.

First, let's add NoRegrets to you Gemfile:
```
group :test do
  gem "no-regrets"
end
```

and to your `rails_helper.rb`:
```
require 'no_regrets'
```

And let's add a check with NoRegrets:
```
require "rails_helper"

RSpec.describe "Homepage", js: true do
  it "load the homepage properly" do
    visit "/"
    expect(page).to have_content "Welcome to my awesome site!"

    NoRegrets.check_screenshot_for_regressions("homepage")
  end
end
```

And let's run the spec:
<img width="958" alt="No Regrets demo screenshot" src="https://user-images.githubusercontent.com/1840367/48943779-97d54e00-ef24-11e8-9458-3c2b1594cfe3.png">

This created a new file called `spec/support/no_regret_fingerprints.yml`, which holds the fingerprints for all the screenshots of your test suite. You should commit this file to version control, as it will be used to know if a screenshot has changed.

Now, let's do a random css modification, and run the spec again:

<img width="1133" alt="No regrets demo screenshot" src="https://user-images.githubusercontent.com/1840367/48944039-72950f80-ef25-11e8-8b79-8b33c9c9dde1.png">

And NoRegrets will even open a screenshot of the page, with the edited part circled in red.

## How well does this thing work?

This is still an alpha version. We've just started using it at Enercoop, so I'm making improvements to the gem as we go.
If you have any feedback, good or bad, or any story on how this gem works for you, I'll be happy to hear it! Feel free to open an issue just to chat about the gem.


