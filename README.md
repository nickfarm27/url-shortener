# URL Shortener

URL Shortener is a URL shortener application built with Ruby on Rails, PostgreSQL, Redis, and Remix.

## Features

- Shorten URLs: A feature that allows users to create short URLs for long URLs.
- Analytics: A feature that provides analytics on the number of clicks, the countries where the clicks originated, and a click log for each shortened URL.

## Installation

To get started with the project, follow these steps:

1. Clone the repository:

```bash
git clone https://github.com/nickfarm27/url-shortener.git
```

2. Change into the project directory:

```bash
cd url-shortener
```

3. Use the following versions for the project (the versions can be found in `.tool-versions` file):

- Ruby: 3.3.4
- Node: 20.18.0

4. This monorepo stores the rails app in the `api` directory and the client app in the `client` directory. 
5. To set up the rails app, run the following command:

```bash
cd api
bundle install

# Set up the environment variables
cp .env.sample .env

# Set up the database
bin/rails db:prepare
```

6. To set up the client app, run the following command:

```bash
cd .. # (if you are currently in the /api directory)
cd client

# Set up the environment variables
cp .env.sample .env

yarn install
```

## Starting the application

There are two ways to start the application: using Overmind or manually.

### Overmind

If you have [Overmind](https://github.com/DarthSim/overmind) installed, you can use the following command to start all processes of the application. This will start Redis, Sidekiq, the Rails server, and the Remix server.

```bash
overmind start -f Procfile.dev
```

Then open your browser and navigate to `http://localhost:5173` to access the application.

### Manual

1. Start the Remix server:

```bash
cd client #(from the /url-shortener directory)
yarn dev
```

2. Change into the `/api` directory:

```bash
cd api #(from the /url-shortener directory)
```

3. Start Redis:

```bash
redis-server
```

4. Start Sidekiq:

```bash
bundle exec sidekiq
```

5. Start the Rails server:

```bash
rails s
```

6. Open your browser and navigate to `http://localhost:5173` to access the application.