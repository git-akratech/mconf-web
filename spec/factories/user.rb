# This file is part of Mconf-Web, a web application that provides access
# to the Mconf webconferencing system. Copyright (C) 2010-2015 Mconf.
#
# This file is licensed under the Affero General Public License version
# 3 or later. See the LICENSE file.

FactoryGirl.define do
  factory :unconfirmed_user, class: User do
    username
    email
    created_at { Time.now }
    updated_at { Time.now }
    disabled false
    approved true
    password { Forgery::Basic.password :at_least => 6, :at_most => 16 }
    password_confirmation { |user| user.password }
    before(:create) { |user| user.skip_confirmation_notification! }
    after(:create) { |user| user.reload }
    association :profile, factory: :profile

    factory :user, parent: :unconfirmed_user do
      confirmed_at { Time.now }
      after(:create) { |user| user.confirm }

      factory :superuser, class: User, parent: :user do |u|
        after(:create) { |user| user.set_superuser! }
      end
    end
  end

end
