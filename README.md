# MetaSocial

A modern social media platform built with React, TypeScript, Vite, and Supabase.

## Features

- User profiles with customizable avatars and bios
- Photo and text post sharing
- Real-time messaging between users
- Like and comment system
- Follow/unfollow functionality
- Push notifications for interactions
- Responsive mobile-first design
- Real-time feed updates

## Tech Stack

- **Frontend**: React 19, TypeScript, Tailwind CSS
- **Build Tool**: Vite
- **Backend**: Supabase (PostgreSQL + Real-time + Storage + Auth)
- **State Management**: React Context API
- **Routing**: React Router v7

## Prerequisites

- Node.js 18+ and npm
- Supabase CLI (`npm install -g supabase`)
- PostgreSQL (for local development)

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```bash
# Supabase Configuration (required)
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# Server-side only (DO NOT prefix with VITE_)
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here

# Optional: Development configuration  
VITE_APP_URL=http://localhost:5173
VITE_ENABLE_REALTIME=true
VITE_DEBUG_DATABASE=false
VITE_APP_ENV=development
```

You can find your Supabase keys in your [Supabase project dashboard](https://app.supabase.com) under Settings > API.

## Database Setup

### Local Development with Supabase CLI

1. **Initialize Supabase locally:**
   ```bash
   npm run db:start
   ```

2. **Reset database and apply all migrations:**
   ```bash
   npm run db:reset
   ```

3. **Generate TypeScript types from your schema:**
   ```bash
   npm run db:types
   ```

4. **Open Supabase Studio (database GUI):**
   ```bash
   npm run db:studio
   ```

### Database Scripts

```bash
# Start local Supabase services
npm run db:start

# Stop local Supabase services  
npm run db:stop

# Reset database (drops all data, applies migrations and seeds)
npm run db:reset

# Apply new migrations only
npm run db:migrate

# Seed database with sample data (included in db:reset)
npm run db:seed

# Generate TypeScript types from database schema
npm run db:types

# Open Supabase Studio interface
npm run db:studio

# Complete database setup (reset + generate types)
npm run setup:db

# Start database and development server together
npm run dev:full
```

## Installation and Development

1. **Clone and install dependencies:**
   ```bash
   git clone <repository-url>
   cd socialApp
   npm install
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual Supabase credentials
   ```

3. **Start local Supabase and set up database:**
   ```bash
   npm run setup:db
   ```

4. **Start the development server:**
   ```bash
   npm run dev
   ```

5. **Or start everything together:**
   ```bash
   npm run dev:full
   ```

## Database Schema

The application uses a comprehensive PostgreSQL schema with the following main tables:

- `profiles` - User profile information
- `posts` - User posts with content and media
- `likes` - Post likes with user relationships  
- `comments` - Post comments with threading support
- `follows` - User follow relationships
- `messages` - Direct messages between users
- `notifications` - System and user notifications

For detailed schema documentation, see [docs/database-schema.md](docs/database-schema.md).

## API and Real-time Features

The application uses Supabase RPC functions for complex queries and real-time subscriptions for live updates:

- **Feed queries**: Optimized post retrieval with user context
- **Real-time messaging**: Instant message delivery and read status
- **Live notifications**: Real-time interaction alerts
- **Post interactions**: Live like/comment updates
- **User presence**: Online status and typing indicators

## Building for Production

```bash
# Create production build
npm run build

# Preview production build locally
npm run preview

# Run linter
npm run lint
```

## Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── auth/           # Authentication components
│   ├── layout/         # Layout and navigation
│   └── ui/            # Base UI components
├── contexts/           # React context providers  
├── hooks/             # Custom React hooks
├── lib/               # Core utilities and API clients
├── pages/             # Route page components
├── types/             # TypeScript type definitions
└── utils/             # Helper functions and constants

supabase/
├── migrations/        # Database migrations
└── seed.sql          # Sample data for development
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.
import reactDom from 'eslint-plugin-react-dom'

export default defineConfig([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```
