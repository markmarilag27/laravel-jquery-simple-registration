# 🚀 Laravel Dockerized Environment

This repository contains a fully Dockerized setup for running a Laravel application using **PHP-FPM**, **Nginx**, and **Composer**, along with convenient shell scripts to simplify development workflows.

---

## 📦 Requirements

Before you begin, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- Bash (for running helper scripts)
- Optional: SSH key access for private Git repositories (e.g., for Composer dependencies)

---

## 📁 Project Structure

```
project-root/
├── app/                      # Laravel application
├── docker-compose.yml        # Docker Compose setup
├── Dockerfile                # Multi-stage Laravel image build
├── nginx.conf                # Nginx server configuration
├── php.ini                   # Custom PHP configuration
├── run-start.sh              # Script to start containers
├── run-stop.sh               # Script to stop containers
├── run-container.sh          # Script to access the app container
└── README.md
```

---

## 🧰 Setup & Usage

### 🔑 Step 1: Make Scripts Executable

Run this once to make the helper scripts executable:

```bash
chmod +x run-start.sh run-stop.sh run-container.sh
```

---

### 🚀 Step 2: Start the Environment

To build and start all containers in the background:

```bash
./run-start.sh
```

- App will be available at: http://localhost
- PHP-FPM and Nginx will run in the same container
- Logs stream to Docker's stdout/stderr

---

### 🛑 Step 3: Stop the Environment

To gracefully shut down and remove the containers:

```bash
./run-stop.sh
```

---

### 🐚 Step 4: Enter the Container

To open a shell session in the `app` container:

```bash
./run-container.sh
```

---

## 🗂 Laravel-Specific Notes

Once inside the container (`./run-container.sh`), typical Laravel commands work as expected:

```bash
# Install dependencies
composer install

# Generate application key
php artisan key:generate

# Run migrations
php artisan migrate

# Run tests
php artisan test
```

Ensure your `.env` file is configured before running `artisan` commands.

---

## 🔐 SSH Access for Private Git

If you're accessing private Git repositories during development or via Composer:

1. Mount your SSH keys into the container (already handled in `docker-compose.yml`):

    ```yaml
    volumes:
      - ~/.ssh:/home/laravel/.ssh
    ```

2. Ensure correct permissions on your **host machine**:
    ```bash
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/*
    ```

3. Set `GIT_SSH_COMMAND` to disable host verification if needed:
    ```yaml
    environment:
      - GIT_SSH_COMMAND=ssh -o StrictHostKeyChecking=no
    ```

---

## ⚙ PHP & Nginx Configuration

- PHP-FPM runs with a custom `php.ini` (`/usr/local/etc/php/php.ini`)
- Laravel is served from `/var/www/html/public`
- Nginx configuration is located in `nginx.conf`

To customize:
- Update `php.ini` for PHP settings
- Update `nginx.conf` to modify web server behavior

---

## 🧪 Testing in Docker

To run tests inside the container:

```bash
./run-container.sh
php artisan test
```

Or using `docker compose` directly:

```bash
docker compose exec app php artisan test
```

---

## ✅ Environment Overview

| Component | Description                     |
|----------|----------------------------------|
| PHP      | 8.4 FPM Alpine                   |
| Web      | Nginx (Alpine)                   |
| Composer | Installed globally               |
| User     | `laravel` (UID 1000)             |
| Workdir  | `/var/www/html`                  |
| App URL  | http://localhost                 |

---

## 📄 License

This project is licensed under the [MIT License](LICENSE) — feel free to use, modify, and adapt it to your needs.

---

## 🙋 Support

For questions, issues, or improvements, feel free to open an issue or submit a PR.
