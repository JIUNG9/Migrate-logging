# 📦 log4j2-to-logback-migration

> 🛠 Automated Shell Script & GitHub Actions Workflow to Migrate Spring Boot Logging System from `log4j2` to `logback`, with Google Cloud Logging Compatibility

---

## 📚 Overview

This project provides a robust and automated solution to migrate Spring Boot projects from `log4j2` to `logback` — which is **required for Google Cloud Logging integration**.

It includes:
- ✅ A **Shell script** that modifies `pom.xml` by:
  - Removing `spring-boot-starter-log4j2`
  - Removing `logback` exclusions
  - Adding `spring-boot-starter-logging` for Logback
- ✅ Optional integration with **Google Cloud Logging** dependencies
- ✅ A **GitHub Actions workflow** to:
  - Auto-run the migration script on changes to `pom.xml`
  - Validate via `mvn verify`
  - Auto-commit and push changes if needed

---

## 📂 Folder Structure

```
log4j2-to-logback-migration/
├── pom.xml
├── scripts/
│   └── migrate-logging.sh
└── .github/
    └── workflows/
        └── logging-migration.yml
```

---

## ⚙️ Setup Instructions

### ✅ Prerequisites

- Java + Maven environment
- Git + GitHub repository
- `xmlstarlet` (auto-installed by the script)
- GitHub Actions enabled (optional for CI/CD)

---

### 🔧 Run Manually (CLI)

```bash
cd your-project/
bash scripts/migrate-logging.sh
```

The script will:
- Remove log4j2 dependencies
- Add logback support
- Auto-commit to Git if changes are detected

### 🤖 Run via CI/CD

The GitHub Actions workflow `.github/workflows/logging-migration.yml` is triggered on any change to `pom.xml`.

It performs:
- Auto migration
- Build verification (`mvn clean verify`)
- Auto-commit and push (only if changes were made)

---

## 📝 Sample Maven Result After Migration

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-logging</artifactId>
</dependency>
<dependency>
  <groupId>org.apache.logging.log4j</groupId>
  <artifactId>log4j-to-slf4j</artifactId>
</dependency>
<dependency>
  <groupId>com.google.cloud</groupId>
  <artifactId>google-cloud-logging-logback</artifactId>
  <version>0.127.10-alpha</version>
</dependency>
```

---

## 🧪 Tested With

- Spring Boot 2.x & 3.x
- Multi-module Maven projects
- GitHub Actions (Ubuntu Runners)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔁 Auto Migration Script | One-command logging migration |
| 📋 Git Auto-Commit | Only commits changes if pom.xml was modified |
| 🔧 CI/CD Pipeline (GitHub) | End-to-end validation with mvn verify |
| ☁️ Google Cloud Logging Support | logback compatibility for GCL |

---

## 🙋 FAQ

### Why remove log4j2?
Because Google Cloud Logging uses logback, which conflicts with log4j2. Spring Boot allows only one logging implementation at a time.

### Can I still use Lombok's @Slf4j?
Yes! Lombok binds to the SLF4J interface — so as long as log4j2 is bridged to SLF4J and SLF4J routes to logback, it works perfectly.
