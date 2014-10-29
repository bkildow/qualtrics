require 'ostruct'

FactoryGirl.define do
  factory :shibboleth, :class => 'OpenStruct' do
    name_n 'buckeye.1'
    email 'buckeye.1@osu.edu'
    first_name 'Brutus'
    last_name 'Buckeye'
    emplid '111111111'
    timestamp '2014-09-11T15:33:48'
    expiration '2014-09-11T15:33:48'
  end
end
