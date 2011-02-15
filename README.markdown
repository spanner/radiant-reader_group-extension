# Reader Group Extension

The basic purpose of this extension is to control access to pages in your public site. It allows you to create a group of readers, and to make pages visible only to selected groups. It also provides a useful group-messaging interface using the reader extensions html-mailer and a batch-import function for inviting people into your groups.

In combination with our other extensions it also lets you control access to forums, downloads and assets. I hope other people will find the framework useful and apply it to their own requirements. Any resource class can be given group-based access control with a single call:

	class Widget << ActiveRecord::Base
	  has_groups
	end

This extension doesn't group your users or affect the admin interface in any way, apart from adding (quite a lot of) machinery for looking after groups and their messages. As always, readers have their own self-management interface that looks like the rest of your site. They never see the admin pages.

This works with multi_site (but right now the reader extension doesn't, or not very well). If you use [our fork](https://github.com/spanner/radiant-paperclipped_multisite-extension/tree) then groups are automatically site-scoped.

## Latest

* all group relations are now habtm, so that any object can have one or more groups. Objects with only one group behave as before. Some of the scopes are quite thickety now so there may be bugs in the corners. Migration required.
* groups can be marked subscribable, which puts a checkbox to subscribe or unsubscribe on the readers' registration and preference forms.

## Status

This has been brought across from a previous version that grouped users instead of working in the reader framework, so it's a mixture of the well-used and the just-invented, but the tests are fairly comprehensive. It's in use on a couple of biggish sites and seems fairly robust.

## Requirements

Radiant 0.9.x and the [reader](https://github.com/spanner/radiant-reader-extension) extension.

## Installation

Once you've got the reader extension in, the rest is easy:

	gem install radiant-reader_group-extension

or vendored:

	git submodule add git://github.com/spanner/radiant-reader_group-extension.git vendor/extensions/reader_group
	rake radiant:extensions:reader_group:migrate
	rake radiant:extensions:reader_group:update

## Bugs and comments

On github, please.

## Author and copyright

* Copyright spanner ltd 2007-11.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org

