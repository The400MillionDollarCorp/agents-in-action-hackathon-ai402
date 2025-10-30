# AGENTS.md - AI402 Platform

## Build/Test Commands
- **Backend dev**: `cd backend && npm run dev` (runs on port 5000)
- **Frontend dev**: `cd frontend && npm start` (runs on port 3000)
- **Agent dev**: `cd "cdp agentkit x402 flow" && npm start`
- **Frontend test**: `cd frontend && npm test` (runs Jest tests)
- **Backend seed**: `cd backend && node scripts/seed-llm-resources.js` or `node scripts/seed-mcp-resources.js`

## Architecture
- **Monorepo**: `backend/` (Express.js + MongoDB), `frontend/` (React 19 + Tailwind), `cdp agentkit x402 flow/` (CDP AgentKit)
- **Backend**: REST API with x402 payment verification, MongoDB models (Resource, Transaction), services (llmService, mcpService, proxyService)
- **Frontend**: React Router pages (LandingPage, Marketplace, ResourceDetails, Playground, ListResource, Dashboard)
- **Database**: MongoDB with Mongoose ODM - models in `backend/src/models/`
- **Blockchain**: Base Sepolia network, x402 protocol for USDC micropayments, x402-express middleware
- **AI**: AWS Bedrock for LLM hosting, MCP server integration via @modelcontextprotocol/sdk

## Code Style
- **Type**: ES modules (`"type": "module"`) - use `import/export`, not `require()`
- **Imports**: Use `.js` extensions for local imports (e.g., `import Resource from "./models/Resource.js"`)
- **Frontend**: React functional components with hooks, Tailwind CSS for styling
- **Backend**: Express routes in `routes/`, business logic in `services/`, Mongoose models in `models/`
- **Naming**: camelCase for variables/functions, PascalCase for React components and Mongoose models
- **Error handling**: Use try/catch blocks, return appropriate HTTP status codes (402 for payment required)
- **Env vars**: Use dotenv, check `.env.example` files for required variables (MONGODB_URI, FACILITATOR_URL, AWS credentials, CDP keys)
