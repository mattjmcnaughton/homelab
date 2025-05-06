# frontier-llm-providers

I access Anthropic, OpenAI, and PerplexityAI "directly" (i.e. not via Bedrock).

For each, I purchase API credits in small increments ($5). I currently manage
teams/keys via the UI, and then store them in AWS secrets manager. I try and
give solid names for teams/orgs, keys, etc... but it's not completely
standardized. I utilize some combination of `personal`, `mattjmcnaughton`,
`homelab`, and the application (i.e. `litellm`).

I still utilize `litellm` as the proxy to these providers (for unified billing),
etc.

Note, PerplexityAI uses DeepSeek, but it hosts DeepSeek itself on AWS in
us-east-1.
