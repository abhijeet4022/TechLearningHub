# What is Large Language Model LLM ?
- LLM stands for Large Language Model , which is a type of artificial intelligence (GenAI) models that are really good at understanding and generating humanlike text based on the input they receive. And these input called as prompt. These models are trained on vast amounts of text data and can perform various natural language processing tasks such as text generation, translation, summarization, and question-answering.

- GPT - Generative Pre-trained Transformer is a type of LLM Model developed by OpenAI. It uses a transformer architecture to process and generate text, making it capable of understanding context and generating coherent responses.

# What transformer does
- Transformer can convert any input to particular output. It can take any input and convert it to a particular output. For example, it can take a sentence in one language and convert it to another language, or it can take a question and generate an answer.

- GPT Transformer will take the input and based on previous data it will generate the output. It is trained on large amounts of text data to learn patterns, grammar, and context, allowing it to perform tasks like translation, summarization, and conversation.
```mermaid
LLM (Large Language Model)
│
├── GPT Family  (by OpenAI)
│    ├── GPT-3
│    ├── GPT-3.5
│    ├── GPT-4
│    └── GPT-5
│
├── Claude Family (by Anthropic)
│    ├── Claude 1
│    ├── Claude 2
│    └── Claude 3
│
├── LLaMA Family (by Meta)
│    ├── LLaMA 1
│    ├── LLaMA 2
│    └── LLaMA 3
│
├── Gemini Family (by Google DeepMind)
│    ├── Gemini 1
│    ├── Gemini 1.5
│    └── Gemini 2 (in progress)
│
└── Others
├── Mistral (Mistral AI)
├── Falcon (Technology Innovation Institute)
└── Command R (Cohere)
```

## Key takeaway:
    * LLM is the technology type and.
    * GPT-4, Claude, LLaMA, Gemini, etc. are different products/versions built using that technology.

> To see how token works (tokenization) -    https://tiktokenizer.vercel.app/


- Most of the tech gaints are offering atleast one LLM
  * OpenAI → GPT series (GPT-3.5, GPT-4, GPT-4o, GPT-5) — used in ChatGPT
  * Google → Bard (now rebranded as part of Gemini), LaMDA, and PaLM — used in Bard/Gemini chatbot
  * Meta → LLaMA (LLaMA 1, 2, and 3) — open for research & commercial use
  * Anthropic → Claude (Claude 1, 2, and 3) — safety-focused conversational AI (Claude Chat)
  * Hugging Face → BLOOM — large open-source multilingual LLM
  * NVIDIA → NeMo — framework and collection of LLMs for customization and deployment
  * xAI → Grok series (Grok-1 to Grok-4) — used in Grok Chat

## LLM usually means text-only, but when a model can handle images, voice, and other inputs, it’s called a Multimodal Model.

### LLM
    * Designed for language tasks (reading, writing, reasoning in text).
    * Input: Text
    * Output: Text
    * Example: Early GPT-3 (could only chat in text).

### Multimodal Model
    * Can process multiple types of data — not just text.
    * Inputs can be text, images, audio, video, etc.
    * Outputs can also be in different formats (text, image, audio).
    * Examples:
        * GPT-4o → can take text, images, and voice.
        * Gemini 1.5 → can handle text + images.
        * Claude 3 with vision → can interpret images.

* In the backend, whether it’s a plain text LLM or a fancy multimodal AI, the Transformer architecture is still the core engine.  But for multimodal models, it’s not only a transformer — there are often extra components to handle non-text data before it reaches the LLM part.

### How it works under the hood
    1. Text input → Goes straight into the transformer-based LLM.
    2. Image input → First goes through a vision encoder (often a Vision Transformer, ViT, or CNN) to turn the image into a sequence of tokens.
    3. Audio input → Goes through an audio encoder (can be based on transformers, like Whisper, or other architectures) to convert sound into tokens.
    4. All tokens (from text, image, audio) are fed into the same main transformer so the model can reason about them together.

### Key point
    * For pure LLMs (like GPT-3 or LLaMA 2), it’s just a transformer that works with text tokens.
    * For multimodal models (like GPT-4o, Gemini, Claude with vision), the transformer is still the brain, but it’s paired with special encoders for each type of data.

## Here’s a simple backend flow diagram showing how a multimodal model processes different types of inputs before the Transformer LLM brain does the reasoning:
```mermaid
             ┌──────────────────┐
Text  ─────▶ │ Tokenizer         │
             └──────────────────┘
                       │
Image ───▶ [Vision Encoder (ViT/CNN)] ──┐
                                        │
Audio ───▶ [Audio Encoder (Whisper, etc)]┤
                                        ▼
                             ┌──────────────────┐
                             │ Transformer LLM  │
                             │  (Core Brain)    │
                             └──────────────────┘
                                        │
                             ┌──────────────────┐
                             │ Output Decoder   │
                             └──────────────────┘
                                        │
                        Text / Image / Audio Output

```
### Step-by-step:
    1. Text input → Goes through a tokenizer to turn words into tokens.
    2. Image input → Goes through a vision encoder to turn pixels into embeddings (token-like vectors).
    3. Audio input → Goes through an audio encoder to turn sound waves into embeddings.
    4. All embeddings meet inside the Transformer (the actual LLM brain).
    5. Output decoder converts the model’s predictions back into human-readable form — text, image, or audio.

