# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{radiant-reader_group-extension}
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["spanner"]
  s.date = %q{2011-02-15}
  s.description = %q{Adds group-based page access control to radiant.}
  s.email = %q{will@spanner.org}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "app/controllers/admin/group_invitations_controller.rb",
     "app/controllers/admin/groups_controller.rb",
     "app/controllers/admin/memberships_controller.rb",
     "app/controllers/admin/permissions_controller.rb",
     "app/helpers/admin/groups_helper.rb",
     "app/models/group.rb",
     "app/models/membership.rb",
     "app/models/permission.rb",
     "app/views/admin/group_invitations/new.html.haml",
     "app/views/admin/group_invitations/preview.html.haml",
     "app/views/admin/groups/_add_readers.html.haml",
     "app/views/admin/groups/_form.html.haml",
     "app/views/admin/groups/_list_head.html.haml",
     "app/views/admin/groups/edit.html.haml",
     "app/views/admin/groups/index.html.haml",
     "app/views/admin/groups/new.html.haml",
     "app/views/admin/groups/remove.html.haml",
     "app/views/admin/groups/show.html.haml",
     "app/views/admin/memberships/_reader.html.haml",
     "app/views/admin/messages/_function.haml",
     "app/views/admin/messages/_list_function.haml",
     "app/views/admin/messages/_list_notes.html.haml",
     "app/views/admin/messages/_message_description.html.haml",
     "app/views/admin/messages/_message_group.html.haml",
     "app/views/admin/pages/_listed.html.haml",
     "app/views/admin/pages/_page_groups.html.haml",
     "app/views/admin/permissions/_page.html.haml",
     "app/views/admin/readers/_reader_groups.html.haml",
     "app/views/readers/_memberships.html.haml",
     "app/views/site/not_allowed.html.haml",
     "config/locales/en.yml",
     "config/routes.rb",
     "db/migrate/001_create_groups.rb",
     "db/migrate/20090921125654_group_messages.rb",
     "db/migrate/20091120083119_groups_public.rb",
     "db/migrate/20110214101339_multiple_ownership.rb",
     "lib/admin_messages_controller_extensions.rb",
     "lib/group_message_tags.rb",
     "lib/group_ui.rb",
     "lib/grouped_message.rb",
     "lib/grouped_model.rb",
     "lib/grouped_page.rb",
     "lib/grouped_reader.rb",
     "lib/reader_activations_controller_extensions.rb",
     "lib/reader_notifier_extensions.rb",
     "lib/reader_sessions_controller_extensions.rb",
     "lib/readers_controller_extensions.rb",
     "lib/site_controller_extensions.rb",
     "lib/tasks/reader_group_extension_tasks.rake",
     "public/images/admin/chk_auto.png",
     "public/images/admin/chk_off.png",
     "public/images/admin/chk_on.png",
     "public/images/admin/edit.png",
     "public/images/admin/error.png",
     "public/images/admin/message.png",
     "public/images/admin/new-group.png",
     "public/images/admin/populate.png",
     "public/images/admin/rdo_off.png",
     "public/images/admin/rdo_on.png",
     "public/stylesheets/sass/admin/reader_group.sass",
     "radiant-reader_group-extension.gemspec",
     "reader_group_extension.rb",
     "spec/controllers/site_controller_spec.rb",
     "spec/datasets/group_messages_dataset.rb",
     "spec/datasets/group_readers_dataset.rb",
     "spec/datasets/group_sites_dataset.rb",
     "spec/datasets/groups_dataset.rb",
     "spec/models/group_spec.rb",
     "spec/models/message_spec.rb",
     "spec/models/page_spec.rb",
     "spec/models/reader_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/spanner/radiant-reader_group-extension}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Group-based access control for the radiant CMS}
  s.test_files = [
    "spec/controllers/site_controller_spec.rb",
     "spec/datasets/group_messages_dataset.rb",
     "spec/datasets/group_readers_dataset.rb",
     "spec/datasets/group_sites_dataset.rb",
     "spec/datasets/groups_dataset.rb",
     "spec/models/group_spec.rb",
     "spec/models/message_spec.rb",
     "spec/models/page_spec.rb",
     "spec/models/reader_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<radiant>, [">= 0.9.0"])
      s.add_runtime_dependency(%q<radiant-reader-extension>, [">= 0"])
    else
      s.add_dependency(%q<radiant>, [">= 0.9.0"])
      s.add_dependency(%q<radiant-reader-extension>, [">= 0"])
    end
  else
    s.add_dependency(%q<radiant>, [">= 0.9.0"])
    s.add_dependency(%q<radiant-reader-extension>, [">= 0"])
  end
end

