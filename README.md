# DDNS client

DDNS client

## Requirement
* ruby
** requires json

## Usage

* debug
    $ git clone https://github.com/wataken44/ddns.git
    $ cd ddns
    $ mv config-sample.json config.json
    $ vi config.json
    $ ruby ddns.rb -d
* run with cron
    $ crontab -e

    0 * * * * ruby /home/wataken44/ddns/ddns.rb

## License

BSD 2-Clause License

## Contact

http://twitter.com/wataken44
