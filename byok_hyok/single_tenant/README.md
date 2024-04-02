# Single-tenant Hold-Your-Own-Key

This example assumes that you have a single domain as your deployment is single-tenant. This is
opposed to the multi-tenant architecture where you have a "parent" domain that is used for common
configuration and "subdomains" that are unique to each tenant/customer.

In this configuration, we simply auth to Antimatter using our secret API key, then take the token
and use it to generate a URL to the HYOK onboarding page. The token is valid for at least an hour.