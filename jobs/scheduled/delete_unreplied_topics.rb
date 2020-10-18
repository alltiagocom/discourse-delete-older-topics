# frozen_string_literal: true

module Jobs
  class DeleteUnrepliedTopics < ::Jobs::Scheduled
    every 2.hours

    def execute(args)
      return unless SiteSetting.delete_unreplied_topics_enabled?
      days = SiteSetting.delete_unreplied_topics_days
      return unless days.to_i > 0 

      Topic.where(category_id: SiteSetting.delete_unreplied_topics_categories.split('|'))
        .where("created_at < '#{days.to_i.days.ago}'")
        .where("posts_count = 1")
        .each do |t| 
          next if t.category.topic_id == t.id # skip category intro topics

          if SiteSetting.delete_unreplied_topics_dry_run?
            Rails.logger.error("DeleteUnrepliedTopics would remove Topic ID #{t.id} (#{t.title}) (dry run mode)")
          else
            Rails.logger.error("DeleteUnrepliedTopics removing Topic ID #{t.id} (#{t.title})")
            post = t.posts.first
            PostDestroyer.new(Discourse.system_user, post).destroy
          end
      end
    end
  end
end
