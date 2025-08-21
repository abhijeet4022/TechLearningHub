## Key takeaways for this course
This course on "Prompt Engineering: How to Talk to the AIs" covers several important concepts. Here are the key takeaways:

Core Concepts of Generative AI: Understand the basics of generative AI and its impact on various fields.
Prompt Engineering: Learn the elements of a basic prompt, including instructions, questions, input data, and examples, and explore more advanced techniques like chain-of-thought prompting.
Practical Examples: Review examples of prompts for both image generation and large-language models (LLMs), and learn advanced prompts that can transform business operations.

By the end of the course, you'll have a solid foundation in prompt engineering and be equipped with practical tips and tricks to effectively communicate with AI systems.


## Transcript
Talking to the AIs

Selecting transcript lines in this section will navigate to timestamp in the video
If you're here, you probably have already heard about ChatGPT and GPT-4, and might have even come across the term prompt engineering in that context. Is prompt engineering something you should care about? Is it relevant to you and your current role? Let me answer that with a personal story. Before I joined LinkedIn to lead generative AI efforts, I co-founded a startup in the AI for healthcare space. We were at the forefront of using the state-of-the-art AI models in a high stakes domain like healthcare. At some point, it became clear that in order to make things work, the medical doctors in our team needed to be very involved in designing the interface with the AI. So we had to have medical doctors become involved in doing prompt engineering. Think about it. If medical doctors in the future will need to understand how to interact with the AI, chances are you will too. In this course, I will give you a gentle introduction on how to talk to the AI. As you will see shortly, most of it boils down to how to follow good prompt engineering practices.

---
```text
Talking to the AIs

Selecting transcript lines in this section will navigate to timestamp in the video
If you're here, you probably have already heard about ChatGPT and GPT-4, and might have even come across the term prompt engineering in that context. Is prompt engineering something you should care about? Is it relevant to you and your current role? Let me answer that with a personal story. Before I joined LinkedIn to lead generative AI efforts, I co-founded a startup in the AI for healthcare space. We were at the forefront of using the state-of-the-art AI models in a high stakes domain like healthcare. At some point, it became clear that in order to make things work, the medical doctors in our team needed to be very involved in designing the interface with the AI. So we had to have medical doctors become involved in doing prompt engineering. Think about it. If medical doctors in the future will need to understand how to interact with the AI, chances are you will too. In this course, I will give you a gentle introduction on how to talk to the AI. As you will see shortly, most of it boils down to how to follow good prompt engineering practices.
```
---
Prompt Engineering: How to Talk to the AIs with Xavier Amatriain 1 of 2
Prompt Engineering: How to Talk to the AIs
with Xavier Amatriain
Links and Resources
Here are some AI, GPT, and prompt engineering resources you may want to check out. Many of
them have been referenced throughout the course.
Videos
• CMU Advanced NLP 2022: Prompting
• Prompt Engineering 101: Autocomplete, Zero-Shot, One-Shot, and Few-Shot
Prompting (2022)
Blog Posts
• The Biggest Bottleneck for Large Language Model Startups Is UX
−− Post about the broader UX implications of LLMs, with a section on prompting
• Prompt Injection Attacks against GPT-3
−− Post about prompt injection attacks, where the goal is to craft malicious inputs
so that GPT-3 ignores previous directions
• Prompt Engineering
−− Lil’Log post by Lilian Weng about in-context prompting (a.k.a. prompt
engineering) for autoregressive language models
Papers
• Pre-train, Prompt, and Predict: A Systematic Survey of Prompting Methods in Natural
Language Processing (2019)
−− A bit dated (three years old) survey of prompting. It includes a fairly reasonable
taxonomy of prompting methods, but some of them are not very practical.
• Chain of Thought Prompting Elicits Reasoning in Large Language Models (2022)
−− Forcing the LLM to reason step-by-step by giving the right prompt improves results.
• Language Models Are Zero-Shot Reasoners (2022)
−− Fascinating paper that, as continuation of the previous, shows how LLMs reason
better if you simply tell them to reason step-by-step.
• Teaching Algorithmic Reasoning via In-context Learning (2022)
−− This paper covers more advanced prompting. In this case, the authors show how
you can prompt standard LLMs to do complex algorithmic computations given the
right prompt. They also show how skills can not only be taught but also
composed in the prompt.
Prompt Engineering: How to Talk to the AIs with Xavier Amatriain 2 of 2
• Ask Me Anything: A Simple Strategy for Prompting Language Models
−− This is an interesting approach to prompting in which the authors propose multiple
imperfect input prompts and output aggregation through weak supervision
Tools
• Microsoft Prompt Engine
−− NPM utility library for creating and maintaining prompts for large language models
• Interactive Composition Explorer (ICE)
−− A Python library for compositional language model programs
Other Resources
• DAIR Prompt Engineering Guide
• AI Notes
−− Prompt engineering resources
• Advance Prompt Engineering Workshop
---