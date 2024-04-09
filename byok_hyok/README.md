# Hold-Your-Own-Key self-serve flow

This is a short example showing how to use the Antimatter API to generate an authenticated URL that you can direct a customer to. They will land on a pre-authenticated self-serve key management UI where they can configure the root encryption key for their domain, holding it in in AWS, GCP or Azure.

The multi-tenant example has an extra step to reduce the privileges of the token from cross-customer to single-customer scope before generating the URL.