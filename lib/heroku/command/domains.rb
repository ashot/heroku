require "heroku/command/base"

module Heroku::Command

  # manage custom domains
  #
  class Domains < Base

    # domains
    #
    # list custom domains for an app
    #
    #Examples:
    #
    # $ heroku domains
    # === Domain names for myapp
    # example.com
    #
    def index
      validate_arguments!
      domains = api.get_domains(app).body
      if domains.length > 0
        styled_header("Domain names for #{app}")
        styled_array domains.map {|domain| domain["domain"]}
      else
        display("No domain names for #{app}")
      end
    end

    # domains:add DOMAIN
    #
    # add a custom domain to an app
    #
    #Examples:
    #
    # $ heroku domains:add example.com
    # Adding example.com to myapp... done
    #
    def add
      domain = shift_argument
      validate_arguments!
      fail("Usage: heroku domains:add DOMAIN") if domain.to_s.strip.empty?
      action("Adding #{domain} to #{app}") do
        api.post_domain(app, domain)
      end
    end

    # domains:remove DOMAIN
    #
    # remove a custom domain from an app
    #
    #Examples:
    #
    # $ heroku domains:remove example.com
    # Removing example.com from myapp... done
    #
    def remove
      domain = shift_argument
      validate_arguments!
      fail("Usage: heroku domains:remove DOMAIN") if domain.to_s.strip.empty?
      action("Removing #{domain} from #{app}") do
        api.delete_domain(app, domain)
      end
    end

    # domains:clear
    #
    # remove all custom domains from an app
    #
    #Examples:
    #
    # $ heroku domains:clear
    # Removing all domain names for myapp... done
    #
    def clear
      validate_arguments!
      action("Removing all domain names for #{app}") do
        api.delete_domains(app)
      end
    end

  end
end
