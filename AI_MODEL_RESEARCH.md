# EatIQ - AI Model Research (April 2026)

This document evaluates AI models and APIs for two core features:

1. **Food Image Analysis** — photograph a meal, identify foods, estimate portions, return nutritional data
2. **Diet Assistant** — personalized diet advice, meal plans, nutrition Q&A in Turkish

---

## Table of Contents

- [Executive Summary](#executive-summary)
- [Part 1: Food Image Analysis (Vision Models)](#part-1-food-image-analysis)
- [Part 2: Diet Assistant (Text Models)](#part-2-diet-assistant)
- [Part 3: Food-Specific APIs](#part-3-food-specific-apis)
- [Part 4: Architecture Recommendations](#part-4-architecture-recommendations)
- [Part 5: Cost Projections](#part-5-cost-projections)
- [Sources](#sources)

---

## Executive Summary

| Use Case | Recommended Model | Cost per Request | Why |
|---|---|---|---|
| **Food Image Analysis** | Gemini 2.5 Flash (dev) / GPT-4.1-nano (prod) | $0.00034 | Best price-to-quality; free tier for dev |
| **Diet Assistant Chat** | Gemini 2.5 Flash-Lite (dev) / GPT-4.1-nano (prod) | $0.00019 | Fast, cheap, good Turkish |
| **Nutrition Lookup** | USDA FoodData Central + Edamam | FREE | No cost, comprehensive data |

**Estimated monthly cost at 10K daily users:** ~$30-60/month for AI

**Key finding:** We do NOT need different models for image analysis and diet chat. A single cheap model (GPT-4.1-nano or Gemini 2.5 Flash-Lite) handles both well. Use a two-step approach for image analysis: LLM identifies foods → free database provides exact nutrition.

---

## Part 1: Food Image Analysis

### How Image Tokenization Works

- **OpenAI:** low-detail = 85 tokens; high-detail = 85 + 170 per 512x512 tile. Typical food photo (~768px) = ~765 tokens high-detail, 85 tokens low-detail
- **Gemini:** ~258-1,290 tokens per image depending on resolution
- **Claude:** ~1,600 tokens per image

### Baseline Request Size

```
1 food photo ............. ~1,000-1,400 input tokens (image)
Prompt ................... ~200 input tokens
Response (JSON) .......... ~500 output tokens
```

### Vision Model Comparison — Sorted by Cost

| Model | Input $/MTok | Output $/MTok | Cost/Request | Vision Quality | Free Tier |
|---|---|---|---|---|---|
| **Llama 4 Scout** (OpenRouter) | $0.08 | $0.30 | **$0.00026** | Good | Depends on provider |
| **GPT-4.1-nano** | $0.10 | $0.40 | **$0.00034** | Decent | No |
| **Gemini 2.5 Flash-Lite** | $0.10 | $0.40 | **$0.00034** | Good | YES (1,000 req/day) |
| **GPT-4o-mini** | $0.15 | $0.60 | **$0.00051** | Good | No (being deprecated) |
| **Gemini 2.5 Flash** | $0.15 | $0.60 | **$0.00051** | Very Good | YES (250 req/day) |
| **Llama 4 Maverick** (OpenRouter) | $0.15 | $0.60 | **$0.00051** | Very Good | No |
| **DeepSeek V4** | $0.30 | $0.50 | **$0.00067** | Good | 5M free tokens |
| **GPT-4.1-mini** | $0.40 | $1.60 | **$0.00136** | Very Good | No |
| **Qwen 2.5-VL 72B** | $0.80 | $0.80 | **$0.00152** | Very Good | No |
| **Claude Haiku 3.5** | $0.80 | $4.00 | **$0.00344** | Good | Small credits |
| **GPT-4.1** | $2.00 | $8.00 | **$0.00680** | Excellent | No |
| **Gemini 2.5 Pro** | $1.25 | $10.00 | **$0.00675** | Excellent | YES (5 RPM) |
| **GPT-4o** | $2.50 | $10.00 | **$0.00850** | Excellent | No (being deprecated) |
| **Claude Sonnet 4** | $3.00 | $15.00 | **$0.01290** | Excellent | No |

### Detailed Model Notes

#### GPT-4.1-nano — Best Value for Production
- $0.10/$0.40 per MTok (input/output)
- 1M token context window
- Supports vision, fast response
- Cached input: $0.025/MTok (75% off) — cache the system prompt
- Batch API: $0.05/$0.20 (50% off) — useful for reprocessing
- Strong OpenAI ecosystem, most reliable API

#### Gemini 2.5 Flash-Lite — Best for Development
- $0.10/$0.40 per MTok — same price as GPT-4.1-nano
- **FREE tier: 15 RPM, 1,000 requests/day, 250K tokens/min**
- 272 tokens/sec output speed
- 1M context window
- Excellent for prototyping at zero cost

#### Gemini 2.5 Flash — Best Quality/Price Ratio
- $0.15/$0.60 per MTok (non-thinking mode)
- **FREE tier: 10 RPM, 250 requests/day**
- IMPORTANT: Disable "thinking" mode for food analysis — thinking output costs $3.50/MTok vs $0.60
- Very strong multimodal capabilities

#### Models to AVOID for Food Image Analysis
- **GPT-4o / GPT-4o-mini** — being deprecated, use 4.1 family instead
- **Claude Sonnet 4** — $0.013/request is 38x more expensive than GPT-4.1-nano
- **Gemini 2.0 Flash** — shutting down June 1, 2026
- **Pixtral Large** — $0.0058/request, overpriced for what it offers

---

## Part 2: Diet Assistant

### Baseline Request Size

```
System prompt (persona) .. ~500 input tokens
User message ............. ~200 input tokens
Response ................. ~300 output tokens
```

### Text Model Comparison — Sorted by Cost

| Model | Input $/MTok | Output $/MTok | Cost/Request | Speed (t/s) | Turkish Quality | Context |
|---|---|---|---|---|---|---|
| Mistral Nemo (12B) | $0.02 | $0.04 | $0.000026 | Fast | **Weak** | 131K |
| Groq Llama 3.1 8B | $0.05 | $0.08 | $0.000059 | 663 | **Weak** | 128K |
| Groq Llama 4 Scout | $0.11 | $0.34 | $0.000179 | 2,600 | Decent | 512K |
| **GPT-4.1-nano** | $0.10 | $0.40 | **$0.000189** | ~100+ | **Good** | 1M |
| **Gemini 2.5 Flash-Lite** | $0.10 | $0.40 | **$0.000189** | 272 | **Good** | 1M |
| GPT-4o-mini | $0.15 | $0.60 | $0.000285 | 80-100 | Good | 128K |
| Gemini 2.5 Flash | $0.15 | $0.60 | $0.000285 | 220 | Very Good | 1M |
| Mistral Small 3.1 | $0.20 | $0.60 | $0.000320 | Good | Moderate | 128K |
| DeepSeek V3.2 | $0.28 | $0.42 | $0.000322 | 51 | Moderate | 128K |
| Groq Llama 3.3 70B | $0.59 | $0.79 | $0.000650 | 276 | Moderate | 128K |
| GPT-4.1-mini | $0.40 | $1.60 | $0.000760 | Moderate | Very Good | 1M |
| Claude Haiku 3.5 | $0.80 | $4.00 | $0.001760 | Moderate | Good | 200K |

### Key Findings for Turkish Language

- **GPT-4.1-nano & GPT-4o-mini** — Good Turkish from OpenAI's broad multilingual training
- **Gemini 2.5 Flash-Lite** — Good Turkish, Google supports 40+ languages
- **Groq Llama 4 Scout** — Fastest (2,600 t/s) but Turkish quality is weaker than GPT/Gemini
- **Mistral Nemo / Llama 3.1 8B** — Too small for quality Turkish output. Skip.
- **DeepSeek V3** — Trained mainly on Chinese/English. Turkish is secondary. Also: API hosted in China with reliability concerns.

### Models to AVOID for Diet Assistant
- **o4-mini / DeepSeek R1** — Reasoning models, 10+ second latency. Too slow for chat.
- **Llama 3.1 8B / Mistral Nemo** — Too small, weak Turkish
- **Claude Sonnet 4** — $6.60/1K requests. 35x more expensive than nano.
- **DeepSeek V3 direct API** — Reliability concerns for production mobile app

---

## Part 3: Food-Specific APIs

### Dedicated Food Recognition APIs

| API | Pricing | Returns Nutrition? | Accuracy | Turkish Food | Free Tier |
|---|---|---|---|---|---|
| **Calorie Mama** | 1,000 free/month, then paid | Yes (full macros) | **62.9% top-1** (best in studies) | Moderate | Yes (1K/month) |
| **Edamam Vision** | 10,000 free calls, then usage-based | Yes (160+ nutrients) | Good | Weak (US-centric) | Yes (10K calls) |
| **LogMeal** | Credit-based, 30-day trial | Yes (full macros) | 50.6% | Moderate | Yes (trial) |
| **Foodvisor** | Enterprise only (undisclosed) | Yes | Good | Weak (French-focused) | Unknown |
| **Clarifai Food** | $30/month (1K free ops) | No (labels only) | 38% top-1 | No | Yes (1K/month) |
| **FatSecret** | Free for startups | Yes + image recognition addon | Good | Possibly (56 countries) | Yes |
| **Spike Nutrition** | Enterprise (undisclosed) | Yes | Good | Possibly (180+ languages) | Unknown |

### Free Nutrition Databases (No Image Recognition)

| Database | Cost | Foods | Coverage | Rate Limit |
|---|---|---|---|---|
| **USDA FoodData Central** | FREE | 380K+ foods | US foods, detailed nutrients | 1,000/hour |
| **Open Food Facts** | FREE | 4M+ products | 150 countries, packaged foods | Unlimited |
| **Edamam Nutrition API** | FREE tier (1K/day) | 900K+ foods | Good | 1,000/day |
| **Nutritionix** | $299/month min | 1.9M+ foods | US-centric, NLP input | Enterprise |

### Key Insight: LLMs Beat Specialized APIs for Turkish Food

Research shows specialized food recognition APIs are trained on Western/Asian datasets. A benchmark on Turkish cuisine found only **68.2% accuracy** for specialized models on Turkish dishes.

General LLMs (GPT, Gemini) actually perform BETTER on Turkish food because they've been trained on Turkish language text and can recognize dish names like kebab, lahmacun, borek, manti, etc. from images.

---

## Part 4: Architecture Recommendations

### Recommended: Two-Step Hybrid Approach

```
                        FOOD IMAGE ANALYSIS
                        ==================

  [User takes photo]
         |
         v
  [Step 1: Vision Model] -----> GPT-4.1-nano or Gemini 2.5 Flash-Lite
         |                       - Identify each food item
         |                       - Estimate portion size in grams
         |                       - Return Turkish food name + English name
         |                       - Output: structured JSON
         v
  [Step 2: Nutrition DB] -----> USDA FoodData Central (FREE)
         |                       + Edamam Nutrition API (FREE, 1K/day)
         |                       + Custom Turkish food mapping table
         v
  [Full nutritional data per food item]


                        DIET ASSISTANT CHAT
                        ===================

  [User asks question]
         |
         v
  [Same model] ----------------> GPT-4.1-nano or Gemini 2.5 Flash-Lite
         |                        - System prompt: Turkish diet advisor persona
         |                        - User profile context (age, weight, goals, etc.)
         |                        - Responds in Turkish
         v
  [Personalized diet advice]
```

### Why Two-Step Beats Single-Call

| | Single LLM Call | Two-Step (LLM + DB) |
|---|---|---|
| **Nutrition accuracy** | LLMs hallucinate numbers (~40% error on portions/calories) | DB provides verified USDA data |
| **Turkish food support** | Good identification, bad nutrition data | LLM identifies → DB provides exact data |
| **Cost** | Same | Same (DB is free) |
| **Latency** | 1-2 seconds | 1.5-2.5 seconds (acceptable) |
| **Reliability** | Model may return wrong calorie counts | USDA data is verified by nutritionists |

### Why One Model for Both Tasks

We do NOT need separate models for image analysis and diet chat:

- **GPT-4.1-nano** and **Gemini 2.5 Flash-Lite** both support vision AND text
- Same model = single API integration, single billing, simpler codebase
- Cost difference between models is negligible at our scale
- Switch the system prompt, not the model

### Service Naming Recommendation

Since we're model-agnostic, rename the service layer:

```
Current:  ai-analysis.service.ts (OpenAI-specific)
Better:   ai-analysis.service.ts (generic, provider configurable)
```

Use environment variable to switch providers:

```
AI_PROVIDER=openai          # or "gemini" or "anthropic"
AI_MODEL=gpt-4.1-nano       # or "gemini-2.5-flash-lite"
AI_API_KEY=sk-...
```

---

## Part 5: Cost Projections

### Per-Request Costs

| Operation | Model | Input Tokens | Output Tokens | Cost |
|---|---|---|---|---|
| Food image scan | GPT-4.1-nano | ~1,400 | ~500 | $0.00034 |
| Diet chat message | GPT-4.1-nano | ~700 | ~300 | $0.00019 |
| Nutrition lookup | USDA/Edamam | — | — | FREE |

### Monthly Cost at Scale

| Daily Users | Scans/day | Chat msgs/day | Total requests | AI Cost/month |
|---|---|---|---|---|
| 100 | 300 | 500 | 800 | **$0.21** |
| 1,000 | 3,000 | 5,000 | 8,000 | **$2.08** |
| 10,000 | 30,000 | 50,000 | 80,000 | **$20.80** |
| 50,000 | 150,000 | 250,000 | 400,000 | **$104** |
| 100,000 | 300,000 | 500,000 | 800,000 | **$208** |

*Assumes 3 scans + 5 chat messages per active user per day, using GPT-4.1-nano.*

### Cost Optimization Strategies

1. **Cache system prompts** — GPT-4.1-nano cached input is $0.025/MTok (75% off). The 500-token system prompt is reused every request.
2. **Use low-detail image mode** — 85 tokens vs 765 tokens per image. Saves ~90% on image input cost. Test if food recognition quality is acceptable.
3. **Rate limit free users** — 5 scans/day limit already implemented.
4. **Batch processing** — GPT-4.1-nano batch API is 50% off ($0.05/$0.20). Use for nightly reprocessing or analytics.
5. **Gemini free tier for dev** — 1,000 requests/day free. Never pay during development.

### Development Phase Strategy

| Phase | Vision Model | Text Model | Nutrition DB | Cost |
|---|---|---|---|---|
| **Prototyping** | Gemini 2.5 Flash-Lite (free) | Gemini 2.5 Flash-Lite (free) | USDA (free) | **$0** |
| **Beta testing** | GPT-4.1-nano | GPT-4.1-nano | USDA + Edamam (free) | **~$5/month** |
| **Production (10K users)** | GPT-4.1-nano | GPT-4.1-nano | USDA + Edamam | **~$21/month** |
| **Scale (100K users)** | GPT-4.1-nano (batch for analytics) | GPT-4.1-nano | USDA + Edamam + custom DB | **~$208/month** |

---

## Appendix A: Turkish Food Mapping

LLMs can identify Turkish dishes but USDA may not have exact matches. Build a custom mapping table:

| Turkish Name | USDA Equivalent | Calories/100g |
|---|---|---|
| Lahmacun | Flatbread with meat topping | ~270 |
| Karniyarik | Stuffed eggplant with ground beef | ~150 |
| Mercimek corbasi | Lentil soup | ~56 |
| Menemen | Scrambled eggs with tomatoes/peppers | ~140 |
| Simit | Sesame bread ring | ~340 |
| Borek (peynirli) | Cheese-filled pastry | ~310 |
| Manti | Turkish dumplings | ~180 |
| Iskender kebab | Doner kebab with yogurt sauce | ~200 |
| Pide | Turkish flatbread pizza | ~250 |
| Baklava | Layered pastry with nuts/syrup | ~428 |
| Ayran | Yogurt drink | ~37 |
| Dolma (yaprak) | Stuffed grape leaves | ~140 |
| Kofte | Turkish meatballs | ~220 |
| Pilav | Turkish rice pilaf | ~130 |
| Cacik | Yogurt with cucumber | ~50 |

This table should be expanded to 200+ items and stored in the database for fast local lookup before hitting the USDA API.

---

## Appendix B: Provider API Quick Reference

### OpenAI (GPT-4.1-nano)
```
API: https://api.openai.com/v1/chat/completions
SDK: npm install openai
Auth: Bearer token (API key)
Docs: https://platform.openai.com/docs
```

### Google (Gemini 2.5 Flash-Lite)
```
API: https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent
SDK: npm install @google/genai
Auth: API key or OAuth
Docs: https://ai.google.dev/gemini-api/docs
```

### Groq (Llama 4 Scout — speed fallback)
```
API: https://api.groq.com/openai/v1/chat/completions
SDK: OpenAI-compatible (npm install openai, change baseURL)
Auth: Bearer token
Docs: https://console.groq.com/docs
```

### USDA FoodData Central
```
API: https://api.nal.usda.gov/fdc/v1/foods/search
Auth: API key (free, register at https://fdc.nal.usda.gov/api-key-signup)
Rate: 1,000 requests/hour
Docs: https://fdc.nal.usda.gov/api-guide/
```

### Edamam Nutrition Analysis
```
API: https://api.edamam.com/api/nutrition-data
Auth: App ID + App Key (free tier: 1,000/day)
Docs: https://developer.edamam.com/edamam-nutrition-api
```

---

## Sources

### Model Pricing (verified April 2026)
- [OpenAI API Pricing](https://openai.com/api/pricing/)
- [Google Gemini API Pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Anthropic Claude Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- [Groq Pricing](https://groq.com/pricing)
- [Mistral AI Pricing](https://mistral.ai/pricing)
- [DeepSeek API Pricing](https://api-docs.deepseek.com/quick_start/pricing/)

### Model Benchmarks
- [Artificial Analysis LLM Leaderboard](https://artificialanalysis.ai/leaderboards/models)
- [Artificial Analysis Multilingual Benchmark](https://artificialanalysis.ai/models/multilingual)
- [GPT-4.1 Announcement](https://openai.com/index/gpt-4-1/)

### Food APIs
- [Calorie Mama Developer Portal](https://dev.caloriemama.ai/)
- [Edamam Developer](https://developer.edamam.com/)
- [LogMeal API](https://logmeal.com/api/pricing/)
- [USDA FoodData Central](https://fdc.nal.usda.gov/api-guide/)
- [Open Food Facts API](https://openfoodfacts.github.io/openfoodfacts-server/api/)
- [FatSecret Platform API](https://platform.fatsecret.com/)

### Research Papers
- [PMC: Comparison of Food Recognition Platforms](https://pmc.ncbi.nlm.nih.gov/articles/PMC7752530/) — Calorie Mama best at 62.9% top-1
- [PMC: LLM Performance for Nutritional Estimation](https://pmc.ncbi.nlm.nih.gov/articles/PMC12513282/) — ~40% error on portions
- [Turkish Cuisine Benchmark Dataset](https://www.researchgate.net/publication/318035773) — 68.2% accuracy baseline
