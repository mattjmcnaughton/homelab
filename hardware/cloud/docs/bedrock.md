# bedrock

I utilize Bedrock for AI on AWS.

Bedrock requires you to request access to Foundation Models on a per-region
basis.

Afaik, this must be done via the UI (i.e. not Terraform).

As of 2025-05, I've request access to the following models in `us-east-1`:

- Chat
    - Llama 3.3 70B Instruct
    - Llama 3.2 3B Instruct
    - Titan Text G1 - Premier
    - Mistral 7B Instruct
    - DeepSeek R1
        - There's no indication that using DeepSeek for _personal_ projects is
          prohibited. By using via AWS, it's staying on AWS servers.
        - The DeepSeek EULA does not have any "additional" components.
- Embeddings:
    - Titan Text Embeddings V2
    - Cohere Embed English
- Titan Image Generator G1 v2
- Stable Diffusion 3.5 Large (us-west-2 only)

We do _not_ use Anthropic models on AWS, because I don't want to reach out to
request access from Anthropic yet.

We will use Antropic, Perplexity, and ChatGPT models via their respective APIs.
