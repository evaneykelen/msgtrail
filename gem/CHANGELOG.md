# Changelog

## Version 1.0.7

- Replace deprecated URI.escape method

## Version 1.0.6

- Update dependencies

## Version 1.0.5

- Update dependencies

## Version 1.0.4

- Fix full text search % escape issue

## Version 1.0.3

- Add option to publish files to root of publication from 'files' directory

## Version 1.0.2

- Ignore tracker if settings are missing

## Version 1.0.1

- Add full text search to archive page

## Version 1.0.0

- Fix bug with development and runtime dependencies.
- Consider this version stable enough to become 1.0.

## Version 0.9.9

- Add support for favicon.ico ('theme/favicon.ico' will be copied to 'blog/favicon.ico').

## Version 0.9.8

- Fix title case bug.

## Version 0.9.7

- Re-publish due to rubygems.org issue.

## Version 0.9.6

- Replace internal title case code for [Nicetitle gem](https://github.com/evaneykelen/nicetitle/).

## Version 0.9.5

- Add support for ~~strikethrough~~.

## Version 0.9.4

- Add `titlecase` method based on [John Gruber's title casing](https://daringfireball.net/2008/08/title_case_update) rules.

## Version 0.9.3

- Make published and updated date/time datestamps explicit.
- Change feed format from RSS to Atom.

## Version 0.9.2

- Add details to error messages.
- Add plaintext rendering.

## Version 0.9.1

- Fix link to tweets on mobile devices.

## Version 0.9.0

- Condense multiple dashes in slugs into single dash.

## Version 0.8.0

- Remove old packages (trims gem size).

## Version 0.7.0

- Add `track()` helper. Use for example `<%= track("index") %>` or `<%= track("article", article[:slug]) %>` to add a 1x1 pixel image using the following format: `"<img src=\"#{self.config.settings.domain_matter.tracking_pixel_url}?e=#{event}&se=#{sub_event}\" width=\"1\" height=\"1\" alt=\".\"/>"`. The `tracking_pixel_url` setting must be added to the `domain_matter` section in `config.json`. The URL should point to a (transparent) tracking pixel e.g. hosted on AWS CloudFront/S3.

## Version 0.7.0

- Add access to `cfg` variable inside partials.

## Version 0.6.0

- Added changelog.
- Removed unnecessary warning about missing output directory.

## Version 0.5.0

- First production version capable of rendering static files for msgtrail.com.

## Version 0.1.0 - 0.4.0

- Alpha/beta versions.
