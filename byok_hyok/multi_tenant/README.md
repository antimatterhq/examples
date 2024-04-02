# Multi-tenant self-serve Hold-Your-Own-Key setup

This example has two steps: one creates a new domain for a tenant, given a 'nickname'. 
A nickname is usually the identifier you already have for your tenant.

Then, step two shows how to generate the link for this tenant to configure their own key.

Note that unlike the single-tenant example, this is an intermediate step where we transform
a domain token from the parent domain (cross-customer) to a token that is only valid for 
the one tenant domain. This approach allows you to manage a single domain ID and API key 
across all tenants, but still ensure that the token passed to a customer as part of their
management link is scoped to only their data and does not confer any permissions in the 
parent domain or any other customers.

Once we have the reduced-permissions token, we simply generate the URL to the HYOK configuration
page using that token.