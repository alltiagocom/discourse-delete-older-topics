# name: discourse-delete-unreplied-topics
# about: Deletes topics without replies older than x days in certain categories`
# version: 0.1
# required_version: 2.5.0
# author: DiscourseHosting
# url: https://github.com/discoursehosting/discourse-delete-unreplied-topics

enabled_site_setting :delete_unreplied_topics_enabled
after_initialize do
  require_dependency File.expand_path("../jobs/scheduled/delete_unreplied_topics.rb", __FILE__)
end
