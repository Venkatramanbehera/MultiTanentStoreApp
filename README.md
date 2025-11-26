# Multi-Tenant Shop

This is a multi-tenant shop application built with Ruby on Rails. Below are the steps and details to get the application up and running.

---

## Prerequisites

- **Ruby Version**: Ensure you have the Ruby version specified in the `.ruby-version` file.
- **Bundler**: Install Bundler by running `gem install bundler`.
- **Database**: Ensure you have PostgreSQL installed and running.

---

## System Dependencies

- Docker (optional, for containerized development)
- Node.js and Yarn (for JavaScript asset management)
- Redis (for caching and job queues)

---

## Configuration

1. Copy the example environment file and update it with your credentials:
   ```sh
   cp .env.example .env
   ```
2. Update the `.kamal/secrets` file for deployment secrets.

---

## Database Setup

1. Create the database:
   ```sh
   rails db:create
   ```
2. Run migrations:
   ```sh
   rails db:migrate
   ```
3. Seed the database (if applicable):
   ```sh
   rails db:seed
   ```
4. Run All Client Migration
   ```sh
   rails tenants:migrate
   ```

---

## Running the Application

1. Start the Rails server:
   ```sh
   rails server
   ```
2. Access the application at `http://localhost:3000`.

---

## Running Tests

Run the test suite using:

```sh
rails test
```

---

## Services

- **Job Queues**: Managed with ActiveJob and Redis.
- **Asset Management**: Using Webpacker with Yarn.
- **Background Jobs**: Defined in `app/jobs/`.

---

## Deployment Instructions

1. Build the Docker image:
   ```sh
   docker build -t multi_tenant_shop .
   ```
2. Push the image to your container registry.
3. Use Kamal for deployment:
   ```sh
   bin/kamal deploy
   ```

---

## Folder Structure

- `app/`: Contains the main application code (models, controllers, views, etc.).
- `config/`: Configuration files for the application.
- `db/`: Database migrations and schema.
- `lib/`: Custom libraries and modules.
- `test/`: Test suite for the application.

---

## Additional Notes

- **Rubocop**: Code style is enforced using Rubocop. Configuration is in `.rubocop.yml`.
- **Docker**: The application is containerized using the `Dockerfile`.
- **CI/CD**: GitHub Actions workflows are defined in `.github/workflows/`.

---

For more details, refer to the inline comments in the codebase.
