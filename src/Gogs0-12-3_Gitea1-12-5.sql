/* Moving from Gogs 0.12.3 to Gitea 1.12.5

Copyright L. Higgins 2020

Note that Gogs was not a "Clean" install but had been upgraded from 11.9.x

Data was dumped from Gogs, hence "-- Dumping data for table gogs.access: ~30 rows (approximately)" type statements
Any tables with 0 rows can be assumed to be untested.

Converted to 'select into from ' type script so can be reused
Also to adjust to new structure.

*/

SET GLOBAL table_definition_cache = 1024;

SET @giteadb = 'gitea';  -- The freshly installed Gitea database.
SET @sourcedb = 'gogs'; -- The gogs database
SET @targetdb = 'gitea_test'; -- The new Gitea database, may want to rename database after testing.
SET @user1 = 'gitea'; -- Get user with id 1 from this schema.

-- Dumping data for table gogs.user: ~1 rows (approximately)
-- Get User table first as other tables rely on it.
/* Fields - 
    `keep_email_private`, `email_notifications_preference`, `passwd_hash_algo`, `must_change_password`, `language`,`last_login_unix`,`is_restricted`,
    `allow_create_organization`,`visibility`, `repo_admin_change_team_access`,`diff_view_style`, `theme`
    not present in Gogs.
*/
SET @q = CASE @user1
	WHEN @giteadb THEN
        CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`user`
            SELECT *
            FROM `', @giteadb, '`.`user`
            WHERE `id` = 1;
		')
	WHEN @sourcedb THEN
        CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`user` (`id`, `lower_name`, `name`, `full_name`, `email`, `passwd`, `login_type`, `login_source`,
                `login_name`, `type`, `location`, `website`, `rands`, `salt`, `description`, `created_unix`, `updated_unix`, `last_repo_visibility`,
                `max_repo_creation`, `is_active`, `is_admin`, `allow_git_hook`, `allow_import_local`, `prohibit_login`, `avatar`, `avatar_email`,
                `use_custom_avatar`, `num_followers`, `num_following`, `num_stars`, `num_repos`, `num_teams`, `num_members`)
            SELECT `id`, `lower_name`, `name`, `full_name`, `email`, `passwd`, `login_type`, `login_source`,
                `login_name`, `type`, `location`, `website`, `rands`, `salt`, `description`, `created_unix`, `updated_unix`, `last_repo_visibility`,
                `max_repo_creation`, `is_active`, `is_admin`, `allow_git_hook`, `allow_import_local`, `prohibit_login`, `avatar`, `avatar_email`,
                `use_custom_avatar`, `num_followers`, `num_following`, `num_stars`, `num_repos`, `num_teams`, `num_members`
            FROM `', @sourcedb, '`.`user`
            WHERE `id` = 1;
		')
END;
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.user: ~2 rows (approximately)
/* Fields - 
    `keep_email_private`, `email_notifications_preference`, `passwd_hash_algo`, `must_change_password`, `language`,`last_login_unix`,`is_restricted`,
    `allow_create_organization`,`visibility`, `repo_admin_change_team_access`,`diff_view_style`, `theme`
    not present in Gogs.
*/
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`user` (`id`, `lower_name`, `name`, `full_name`, `email`, `passwd`, `login_type`, `login_source`,
        `login_name`, `type`, `location`, `website`, `rands`, `salt`, `description`, `created_unix`, `updated_unix`, `last_repo_visibility`,
        `max_repo_creation`, `is_active`, `is_admin`, `allow_git_hook`, `allow_import_local`, `prohibit_login`, `avatar`, `avatar_email`,
        `use_custom_avatar`, `num_followers`, `num_following`, `num_stars`, `num_repos`, `num_teams`, `num_members`)
    SELECT `id`, `lower_name`, `name`, `full_name`, `email`, `passwd`, `login_type`, `login_source`,
        `login_name`, `type`, `location`, `website`, `rands`, `salt`, `description`, `created_unix`, `updated_unix`, `last_repo_visibility`,
        `max_repo_creation`, `is_active`, `is_admin`, `allow_git_hook`, `allow_import_local`, `prohibit_login`, `avatar`, `avatar_email`,
        `use_custom_avatar`, `num_followers`, `num_following`, `num_stars`, `num_repos`, `num_teams`, `num_members`
    FROM `', @sourcedb, '`.`user`
    WHERE `id` != 1;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.access: ~30 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO ', @targetdb, '.access (`id`, `user_id`, `repo_id`, `mode`)
	 SELECT `id`, `user_id`, `repo_id`, `mode`
	 FROM ', @sourcedb, '.access;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.access_token: ~2 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO  ', @targetdb, '.access_token (`id`, `uid`, `name`, `token_hash`, `created_unix`, `updated_unix`)
    SELECT `id`, `uid`, `name`, `sha1`, `created_unix`, `updated_unix`
    FROM ', @sourcedb, '.access_token;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs_keep.action: ~578 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`action` (`id`, `user_id`, `op_type`, `act_user_id`, `repo_id`, `ref_name`, `is_private`, `content`, `created_unix`)
    SELECT `id`, `user_id`, `op_type`, `act_user_id`, `repo_id`, `ref_name`, `is_private`, `content`, `created_unix`
    FROM `', @sourcedb, '`.`action`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.attachment: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`attachment` (`id`, `uuid`, `issue_id`, `comment_id`, `release_id`, `name`, `created_unix`)
    SELECT `id`, `uuid`, `issue_id`, `comment_id`, `release_id`, `name`, `created_unix`
    FROM `', @sourcedb, '`.`attachment`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.collaboration: ~14 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`collaboration` (`id`, `repo_id`, `user_id`, `mode`)
    SELECT `id`, `repo_id`, `user_id`, `mode`
    FROM `', @sourcedb, '`.`collaboration`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.comment: ~55 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`comment` (`id`,`type`,`poster_id`,`issue_id`,`commit_id` ,`line` ,`content`,`created_unix` ,`updated_unix` ,`commit_sha`)
    SELECT `id`, `type`, `poster_id`, `issue_id`, `commit_id`, `line`, `content`, `created_unix`, `updated_unix`, `commit_sha`
    FROM `', @sourcedb, '`.`comment`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `commit_status` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`commit_status`
            SELECT *
            FROM `', @giteadb, '`.`commit_status`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `deleted_branch` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`deleted_branch`
            SELECT *
            FROM `', @giteadb, '`.`deleted_branch`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.deploy_key: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`deploy_key` (`id`, `key_id`, `repo_id`, `name`, `fingerprint`, `created_unix`, `updated_unix`)
    SELECT `id`, `key_id`, `repo_id`, `name`, `fingerprint`, `created_unix`, `updated_unix`
    FROM `', @sourcedb, '`.`deploy_key`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.email_address: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`email_address` (`id`, `uid`, `email`, `is_activated`)
    SELECT `id`, `uid`, `email`, `is_activated`
    FROM `', @sourcedb, '`.`email_address`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `email_hash` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`email_hash`
            SELECT *
            FROM `', @giteadb, '`.`email_hash`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `external_login_user` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`external_login_user`
            SELECT *
            FROM `', @giteadb, '`.`external_login_user`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.follow: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`follow` (`id`, `user_id`, `follow_id`)
    SELECT `id`, `user_id`, `follow_id`
    FROM `', @sourcedb, '`.`follow`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `gpg_key` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`gpg_key`
            SELECT *
            FROM `', @giteadb, '`.`gpg_key`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `gpg_key_import` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`gpg_key_import`
            SELECT *
            FROM `', @giteadb, '`.`gpg_key_import`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.hook_task: ~0 rows (approximately)
-- No `http_method` field
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`hook_task` (`id`, `repo_id`, `hook_id`, `uuid`, `type`, `url`, `signature`, `payload_content`, `content_type`, `event_type`, `is_ssl`, `is_delivered`, `delivered`, `is_succeed`, `request_content`, `response_content`)
    SELECT `id`, `repo_id`, `hook_id`, `uuid`, `type`, `url`, `signature`, `payload_content`, `content_type`, `event_type`, `is_ssl`, `is_delivered`, `delivered`, `is_succeed`, `request_content`, `response_content`
    FROM `', @sourcedb, '`.`hook_task`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.issue: ~41 rows (approximately)
-- Some fields in Gitea do not exist in Gogs
-- `deadline_unix` -- Gogs has db field but no ui, also wierd values, prob from earlier version ?
-- non Gogs fields set to 0 or blank.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`issue` (`id`, `repo_id`, `index`, `poster_id`, `original_author`, `original_author_id`, `name`,
     `content`, `milestone_id`, `priority`, `is_closed`, `is_pull`, `num_comments`, `ref`, `deadline_unix`, `created_unix`, `updated_unix`,
      `closed_unix`, `is_locked`)
    SELECT `id`, `repo_id`, `index`, `poster_id`, "", 0, `name`, `content`, `milestone_id`, `priority`, `is_closed`, `is_pull`,
     `num_comments`, "", 0, `created_unix`, `updated_unix`, 0, 0
    FROM `', @sourcedb, '`.`issue`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.issue: ~41 rows (approximately)
-- Table `issue_assignees` does not exist in Gogs, id in Gitea should autoincrement on inserts.
-- Update - Incuded id as no unique index (`issue_id`,`assignee_id`), stops probs if this run multiple times.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`issue_assignees` (`id`, `issue_id`,`assignee_id`)
    SELECT `id`, `id`, `assignee_id`
    FROM `', @sourcedb, '`.`issue`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `issue_dependency` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`issue_dependency`
            SELECT *
            FROM `', @giteadb, '`.`issue_dependency`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.issue_label: ~101 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`issue_label` (`id`, `issue_id`, `label_id`)
    SELECT `id`, `issue_id`, `label_id`
    FROM `', @sourcedb, '`.`issue_label`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.issue_user: ~82 rows (approximately)
-- Many fields removed in Gitea, maybe in other tables or calculated
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`issue_user` (`id`, `uid`, `issue_id`, `is_read`, `is_mentioned`)
    SELECT `id`, `uid`, `issue_id`, `is_read`, `is_mentioned`
    FROM `', @sourcedb, '`.`issue_user`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `issue_watch` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`issue_watch`
            SELECT *
            FROM `', @giteadb, '`.`issue_watch`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.label: ~53 rows (approximately)
-- Fields `org_id` and `description` not in Gogs
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`label` (`id`, `repo_id`, `name`, `color`, `num_issues`, `num_closed_issues`)
    SELECT `id`, `repo_id`, `name`, `color`, `num_issues`, `num_closed_issues`
    FROM `', @sourcedb, '`.`label`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `language_stat` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`language_stat`
            SELECT *
            FROM `', @giteadb, '`.`language_stat`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.lfs_object: ~0 rows (approximately)
-- ######  WARING  #######  ######  WARING  ####### ######  WARING  #######
-- Don't know how the fields in Gogs map to Gitea
-- Don't know how the two tables in Gitea are linked (Both id's are auto, `repo_id` / `repository_id` ??)
-- The two Gitea tables have gifferent date formats for `created` / `created_unix`
-- Update used `repo_id` -> `id` to stop problems when this is run multiple times.
            SET @q = CONCAT('
                INSERT IGNORE INTO `', @targetdb, '`.`lfs_lock` (`id`, `repo_id`, `path`, `created`)
                SELECT `repo_id`, `repo_id`, `storage`, `created_at`
                FROM `', @sourcedb, '`.`lfs_object`;
            ');
            PREPARE stmt FROM @q;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            SET @q = CONCAT('
                INSERT IGNORE INTO `', @targetdb, '`.`lfs_meta_object` (`oid`, `size`, `repository_id`, `created_unix`)
                SELECT `oid`, `size`, `repo_id`, UNIX_TIMESTAMP(`created_at`)
                FROM `', @sourcedb, '`.`lfs_object`;
            ');
            PREPARE stmt FROM @q;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;
-- ######  END OF WARING  #######  ######  END OF WARING  ####### ######  END OF WARING  #######

-- Dumping data for table gogs.login_source: ~0 rows (approximately)
-- ######  WARING  #######  ######  WARING  ####### ######  WARING  #######
-- 'gogs'.`is_default` has been mapped to `is_sync_enabled`
-- Unmap these fields if this is incorrect.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`login_source` (`id`, `type`, `name`, `is_actived`, `is_sync_enabled`, `cfg`, `created_unix`, `updated_unix`)
    SELECT `id`, `type`, `name`, `is_actived`, `is_default`, `cfg`, `created_unix`, `updated_unix`
    FROM `', @sourcedb, '`.`login_source`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
-- ######  END OF WARING  #######  ######  END OF WARING  ####### ######  END OF WARING  #######


-- Dumping data for table gogs.milestone: ~15 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`milestone` (`id`, `repo_id`, `name`, `content`, `is_closed`, `num_issues`, `num_closed_issues`, `completeness`, `deadline_unix`, `closed_date_unix`)
    SELECT `id`, `repo_id`, `name`, `content`, `is_closed`, `num_issues`, `num_closed_issues`, `completeness`, `deadline_unix`, `closed_date_unix`
    FROM `', @sourcedb, '`.`milestone`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.mirror: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`mirror` (`id`, `repo_id`, `interval`, `enable_prune`, `updated_unix`, `next_update_unix`)
    SELECT `id`, `repo_id`, `interval`, `enable_prune`, `updated_unix`, `next_update_unix`
    FROM `', @sourcedb, '`.`mirror`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.notice: ~0 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`notice` (`id`, `type`, `description`, `created_unix`)
    SELECT `id`, `type`, `description`, `created_unix`
    FROM `', @sourcedb, '`.`notice`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `notification` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`notification`
            SELECT *
            FROM `', @giteadb, '`.`notification`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `oauth2_application` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`oauth2_application`
            SELECT *
            FROM `', @giteadb, '`.`oauth2_application`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `oauth2_authorization_code` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`oauth2_authorization_code`
            SELECT *
            FROM `', @giteadb, '`.`oauth2_authorization_code`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `oauth2_grant` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`oauth2_grant`
            SELECT *
            FROM `', @giteadb, '`.`oauth2_grant`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `oauth2_session` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`oauth2_session`
            SELECT *
            FROM `', @giteadb, '`.`oauth2_session`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.org_user: ~2 rows (approximately)
-- Fields `is_owner` and `num_teams` do not exist in Gitea
-- Think handled by teams.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`org_user` (`id`, `uid`, `org_id`, `is_public`)
    SELECT `id`, `uid`, `org_id`, `is_public`
    FROM `', @sourcedb, '`.`org_user`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.protect_branch: ~0 rows (approximately)
-- Field `name` mapped to `branch_name`.
-- Field `protected` mapped to `can_push`.
-- Field `require_pull_request` not present in Gitea, not mapped
/* Fields   `enable_merge_whitelist`, `whitelist_deploy_keys`, `merge_whitelist_user_i_ds`, `merge_whitelist_team_i_ds`,
	        `enable_status_check`, `status_check_contexts`, `enable_approvals_whitelist`, `approvals_whitelist_user_i_ds`,
            `approvals_whitelist_team_i_ds`, `required_approvals`, `block_on_rejected_reviews`, `block_on_outdated_branch`,
            `dismiss_stale_approvals`, `require_signed_commits`, `protected_file_patterns`, `created_unix`, `updated_unix`
   not present in Gogs */
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`protected_branch` (`id`, `repo_id`, `branch_name`, `can_push`, `enable_whitelist`, `whitelist_user_i_ds`, `whitelist_team_i_ds`)
    SELECT `id`, `repo_id`, `name`, `protected`, `enable_whitelist`, `whitelist_user_i_ds`, `whitelist_team_i_ds`
    FROM `', @sourcedb, '`.`protect_branch`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.protect_branch_whitelist: ~0 rows (approximately)
-- Table `protect_branch_whitelist` doesn't exist in Gitea.


-- Dumping data for table gogs.public_key: ~0 rows (approximately)
-- Field `login_source_id` not present in Gogs, not mapped
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`public_key` (`id`, `owner_id`, `name`, `fingerprint`, `content`, `mode`, `type`, `created_unix`, `updated_unix`)
    SELECT `id`, `owner_id`, `name`, `fingerprint`, `content`, `mode`, `type`, `created_unix`, `updated_unix`
    FROM `', @sourcedb, '`.`public_key`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.pull_request: ~0 rows (approximately)
-- Field `head_user_name` not present in Gitea, not mapped
-- Fields `conflicted_files`,`commits_ahead`,`commits_behind` not present in Gogs, not mapped.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`pull_request` (`id`, `type`, `status`, `issue_id`, `index`, `head_repo_id`, `base_repo_id`, `head_branch`, `base_branch`, `merge_base`, `has_merged`, `merged_commit_id`, `merger_id`, `merged_unix`)
    SELECT `id`, `type`, `status`, `issue_id`, `index`, `head_repo_id`, `base_repo_id`, `head_branch`, `base_branch`, `merge_base`, `has_merged`, `merged_commit_id`, `merger_id`, `merged_unix`
    FROM `', @sourcedb, '`.`pull_request`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `reaction` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`reaction`
            SELECT *
            FROM `', @giteadb, '`.`reaction`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.release: ~0 rows (approximately)
-- Fields `original_author`,`original_author_id`,`is_tag` not present in Gogs, not mapped.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`release` (`id`, `repo_id`, `publisher_id`, `tag_name`, `lower_tag_name`, `target`, `title`, `sha1`, `num_commits`, `note`, `is_draft`, `is_prerelease`, `created_unix`)
    SELECT `id`, `repo_id`, `publisher_id`, `tag_name`, `lower_tag_name`, `target`, `title`, `sha1`, `num_commits`, `note`, `is_draft`, `is_prerelease`, `created_unix`
    FROM `', @sourcedb, '`.`release`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `repo_indexer_status` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`repo_indexer_status`
            SELECT *
            FROM `', @giteadb, '`.`repo_indexer_status`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `repo_redirect` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`repo_redirect`
            SELECT *
            FROM `', @giteadb, '`.`repo_redirect`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `repo_topic` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`repo_topic`
            SELECT *
            FROM `', @giteadb, '`.`repo_topic`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `repo_unit` doesn't exist in Gogs.
SET @q = CONCAT('
    CREATE OR REPLACE VIEW `', @targetdb, '`.`repo_unit_temp` AS
        WITH repo (type,config) AS (
    VALUES
        (1,NULL),
        (2,\'{"EnableTimetracker":true,"AllowOnlyContributorsToTrackTime":true,"EnableDependencies":true}\'),
        (3,\'{"IgnoreWhitespaceConflicts":false,"AllowMerge":true,"AllowRebase":true,"AllowRebaseMerge":true,"AllowSquash":true}\'),
        (4,NULL),
        (5,NULL) 
        )
        SELECT `id` AS `repo_id`,`type`, `config`, `created_unix`
        FROM repo CROSS JOIN `', @sourcedb, '`.`repository`
        ORDER BY `repo_id`,`type`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`repo_unit` (`repo_id`, `type`, `config`, `created_unix`)
    SELECT `repo_id`, `type`, `config`, `created_unix`
    FROM `', @targetdb, '`.`repo_unit_temp`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.repository: ~15 rows (approximately)
-- Field `is_bare` mapped to `is_empty`.
/* Fields -
	`enable_wiki`,
	`allow_public_wiki`,
	`enable_external_wiki`,
	`external_wiki_url`,
	`enable_issues`,
	`allow_public_issues`,
	`enable_external_tracker`,
	`external_tracker_url`,
	`external_tracker_format`,
	`external_tracker_style`,
	`enable_pulls`,
	`pulls_ignore_whitespace`,
	`pulls_allow_rebase`,
	`use_custom_avatar`,
not present in `gitea`.`repository` */

/* Fields -
	`owner_name`,
    `original_service_type`,
    `original_url`,`is_archived`,
    `status`,`is_template`,
    `template_id`,
    `is_fsck_enabled`,
    `close_issues_via_commit_in_any_branch`,
    `topics`,
    `avatar`,
not present in `gogs`.`repository` */
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`repository` (`id`, `owner_id`, `owner_name`, `lower_name`, `name`, `description`, `website`, `default_branch`, `num_watches`, `num_stars`,
        `num_forks`, `num_issues`, `num_closed_issues`, `num_pulls`, `num_closed_pulls`, `num_milestones`, `num_closed_milestones`, `is_private`,
        `is_empty`, is_archived, `is_mirror`, `is_fork`, `fork_id`, `size`, `created_unix`, `updated_unix`)
    SELECT `repository`.`id`, `repository`.`owner_id`, `user`.`name` AS `uname`, `repository`.`lower_name`, `repository`.`name`, `repository`.`description`, `repository`.`website`, `default_branch`, `num_watches`, `repository`.`num_stars`,
        `num_forks`, `num_issues`, `num_closed_issues`, `num_pulls`, `num_closed_pulls`, `num_milestones`, `num_closed_milestones`, `is_private`,
        `is_bare`, 0, `is_mirror`, `is_fork`, `fork_id`, `size`, `repository`.`created_unix`, `repository`.`updated_unix`
    FROM `', @sourcedb, '`.`repository`
    INNER JOIN `', @targetdb, '`.`user`
    ON `', @targetdb, '`.`user`.`id` = `', @sourcedb, '`.`repository`.`owner_id`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
-- Note Above, getting user info fro target db, user table imported before here.

-- Table `review` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`review`
            SELECT *
            FROM `', @giteadb, '`.`review`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.star: ~2 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`star` (`id`, `uid`, `repo_id`)
    SELECT `id`, `uid`, `repo_id`
    FROM `', @sourcedb, '`.`star`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `stopwatch` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`stopwatch`
            SELECT *
            FROM `', @giteadb, '`.`stopwatch`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `task` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`task`
            SELECT *
            FROM `', @giteadb, '`.`task`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.team: ~1 rows (approximately)
-- Fields `includes_all_repositories`,`can_create_org_repo` not present in Gogs, not mapped.
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`team` (`id`, `org_id`, `lower_name`, `name`, `description`, `authorize`, `num_repos`, `num_members`)
    SELECT `id`, `org_id`, `lower_name`, `name`, `description`, `authorize`, `num_repos`, `num_members`
    FROM `', @sourcedb, '`.`team`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.team_repo: ~15 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`team_repo` (`id`, `org_id`, `team_id`, `repo_id`)
    SELECT `id`, `org_id`, `team_id`, `repo_id`
    FROM `', @sourcedb, '`.`team_repo`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.team_user: ~2 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`team_user` (`id`, `org_id`, `team_id`, `uid`)
    SELECT `id`, `org_id`, `team_id`,`uid`
    FROM `', @sourcedb, '`.`team_user`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `topic` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`topic`
            SELECT *
            FROM `', @giteadb, '`.`topic`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `tracked_time` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`tracked_time`
            SELECT *
            FROM `', @giteadb, '`.`tracked_time`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.two_factor: ~0 rows (approximately)
-- Field `user_id` mapped to `uid`.
/* Fields -
    `scratch_salt`,
    `scratch_hash`,
    `last_used_passcode`,
    `updated_unix`
not present in `gogs`.`repository` */
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`two_factor` (`id`, `uid`, `secret`, `created_unix`)
    SELECT `id`, `user_id`, `secret`, `created_unix`
    FROM `', @sourcedb, '`.`two_factor`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `two_factor_recovery_code` doesn't exist in Gitea.

-- Table `u2f_registration` doesn't exist in Gogs.
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`u2f_registration`
            SELECT *
            FROM `', @giteadb, '`.`u2f_registration`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.upload: ~5 rows (approximately)
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`upload` (`id`, `uuid`, `name`)
    SELECT `id`, `uuid`, `name`
    FROM `', @sourcedb, '`.`upload`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Table `user_open_id` not in Gogs
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`user_open_id`
            SELECT *
            FROM `', @giteadb, '`.`user_open_id`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Must get database version from Gitea
SET @q = CONCAT('
            INSERT IGNORE INTO `', @targetdb, '`.`version`
            SELECT *
            FROM `', @giteadb, '`.`version`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.watch: ~34 rows (approximately)
-- Field `mode`is not in Gogs
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`watch` (`id`, `user_id`, `repo_id`)	
    SELECT `id`, `user_id`, `repo_id`
    FROM `', @sourcedb, '`.`watch`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Dumping data for table gogs.webhook: ~0 rows (approximately)
-- Fields `is_system_webhook`,`signature`, `http_method` are not in Gogs
SET @q = CONCAT('
    INSERT IGNORE INTO `', @targetdb, '`.`webhook` (`id`, `repo_id`, `org_id`, `url`, `content_type`, `secret`, `events`, `is_ssl`, `is_active`,
        `hook_task_type`, `meta`, `last_status`, `created_unix`, `updated_unix`)
    SELECT `id`, `repo_id`, `org_id`, `url`, `content_type`, `secret`, `events`, `is_ssl`, `is_active`,
        `hook_task_type`, `meta`, `last_status`, `created_unix`, `updated_unix`
    FROM `', @sourcedb, '`.`webhook`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Finished with temp view
SET @q = CONCAT('
    DROP VIEW `', @targetdb, '`.`repo_unit_temp`;
');
PREPARE stmt FROM @q;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;