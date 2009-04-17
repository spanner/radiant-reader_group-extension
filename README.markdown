# Reader Group Extension

This extension introduces the reader group: a set of readers that can be given permission to access pages, forums, downloads and other public site content. It does not group your users or affect the admin interface (apart from adding a groups tab, of course).

## Requirements

The [reader](https://github.com/spanner/radiant-reader-extension/tree) extension.

## Installation

Once you've got the reader extension in, the rest is easy:

	git submodule add git://github.com/spanner/radiant-reader_group-extension.git vendor/extensions/reader_group
	rake radiant:extensions:reader_group:migrate
	rake radiant:extensions:reader_group:update

## Status

Nearly ready. All the functionality is here and the interface is improving. In trial use on a couple of biggish sites and getting more robust.

Just added: prettified page- and reader-choosers in admin.

## Bugs and comments

In [lighthouse](http://spanner.lighthouseapp.com/projects/26912-radiant-extensions), please, or for little things an email or github message is always welcome.

## Author and copyright

Copyright spanner ltd 2007-9.
Released under the same terms as Rails and/or Radiant.
Contact will at spanner.org

