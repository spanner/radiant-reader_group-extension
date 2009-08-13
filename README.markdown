# Reader Group Extension

If you want to publish pages that only some people can see, this extension may well be the answer. It extends the Reader framework by adding group-membership and group-based access control to the pages in your public site. In combination with our other extensions it also lets you control access to forums, downloads and assets, and it proovides useful shortcuts for batch-importing and messaging groups. I hope other people will find the framework useful and apply it to their own requirements.

This extension doesn't group your users or affect the admin interface at all, apart from adding some machinery for looking after groups. As always, readers have their own self-management interface that looks like the rest of your site. They never see the admin pages.

This works with multi_site. If you use [our fork](https://github.com/spanner/radiant-paperclipped_multisite-extension/tree) then readers and groups are automatically site-scoped.

## Latest

Brought up to date with 0.8 and the latest `multi_site` and `reader` extensions. Some tidying up internally. Admin routes and links moved under /reader for tidiness.

## Status

This has been brought across from a previous version that grouped users instead of working in the reader framework, so it's a mixture of the well-used and the just-invented, but the tests are fairly comprehensive. It's in use on a couple of biggish sites and seems fairly robust.

Next: to restfulise the groups controller and improve the messaging interface with better records and presentation, message templates, spurious inbox, etc.

## Requirements

The [reader](https://github.com/spanner/radiant-reader-extension/tree) and [submenu](https://github.com/spanner/radiant-submenu-extension/tree) extensions.

## Installation

Once you've got the reader extension in, the rest is easy:

	git submodule add git://github.com/spanner/radiant-reader_group-extension.git vendor/extensions/reader_group
	rake radiant:extensions:reader_group:migrate
	rake radiant:extensions:reader_group:update

## Bugs and comments

In [lighthouse](http://spanner.lighthouseapp.com/projects/26912-radiant-extensions), please, or for little things an email or github message is always welcome.

## Author and copyright

* Copyright spanner ltd 2007-9.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org

