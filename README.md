# Dev Note on running tests
I found that running tests without `RAILS_ENV=test` was leading to a handful of spec failures. Seems a bit strange but I didn't want to sweat it. If you see failures, please run specs like so:

```sh
RAILS_ENV=test bin/rspec 
# or
RAILS_ENV=test bundle exec rspec spec
```

JS tests run with the given `yarn test` command

# Perchwell Engineering Take-Home

Welcome to the Perchwell take-home assignment!

# Requirements

Please see the requirements [here](https://github.com/RivingtonHoldings/engineering_take_home/blob/main/REQUIREMENTS.md).

