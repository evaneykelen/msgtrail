### Changelog

##### Version 0.7.0

- Add `track()` helper. Use for example `<%= track("index") %>` or `<%= track("article", article[:slug]) %>` to add a 1x1 pixel image using the following format: `"<img src=\"#{self.config.settings.domain_matter.tracking_pixel_url}?e=#{event}&se=#{sub_event}\" width=\"1\" height=\"1\" alt=\".\"/>"`. The `tracking_pixel_url` setting must be added to the `domain_matter` section in `config.json`. The URL should point to a (transparent) tracking pixel e.g. hosted on AWS CloudFront/S3.

##### Version 0.7.0

- Add access to `cfg` variable inside partials.

##### Version 0.6.0

- Added changelog.
- Removed unnecessary warning about missing output directory.

##### Version 0.5.0

- First production version capable of rendering static files for msgtrail.com.

##### Version 0.1.0 - 0.4.0

- Alpha/beta versions
