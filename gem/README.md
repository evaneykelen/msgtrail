# Build and publish gem

1. Update version number in `version.rb`
2. Update CHANGELOG.md
3. Run `gem build msgtrail.gemspec`

Output example:

```
Successfully built RubyGem
Name: msgtrail
Version: 1.0.6
File: msgtrail-1.0.6.gem
```

4. Run `rake build`

Output example:

```
msgtrail 1.0.6 built to pkg/msgtrail-1.0.6.gem.
```

5. Run `rake install`

Output example:

```
msgtrail 1.0.6 built to pkg/msgtrail-1.0.6.gem.
msgtrail (1.0.6) installed.
```

6. Run `gem push pkg/msgtrail-...`

Output example:

```
gem push gem push pkg/msgtrail-1.0.6.gem

Enter your RubyGems.org credentials.
Don't have an account yet? Create one at https://rubygems.org/sign_up
   Email: {EMAIL ADDRESS OR USERNAME}
Password: {PASSWORD}

You have enabled multi-factor authentication. Please enter OTP code.
Code: {OTP}
Signed in with API key: {API KEY}
Pushing gem to https://rubygems.org...
Successfully registered gem: msgtrail (1.0.6)
```
