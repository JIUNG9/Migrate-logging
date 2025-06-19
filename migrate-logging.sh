```bash
#!/bin/bash

set -e

# ---- Step 0: Install xmlstarlet if not found ----

install_xmlstarlet() {
  echo "[INFO] 'xmlstarlet' not found. Trying to install..."

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt &> /dev/null; then
      sudo apt update && sudo apt install -y xmlstarlet
    else
      echo "[ERROR] apt not found. Please install xmlstarlet manually."
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &> /dev/null; then
      brew install xmlstarlet
    else
      echo "[ERROR] Homebrew not found. Please install xmlstarlet manually."
      exit 1
    fi
  elif [[ "$OS" == "Windows_NT" ]]; then
    if command -v choco &> /dev/null; then
      choco install xmlstarlet -y
    else
      echo "[ERROR] Chocolatey not found. Please install xmlstarlet manually or add it to PATH."
      exit 1
    fi
  else
    echo "[ERROR] Unsupported OS: $OSTYPE"
    exit 1
  fi
}

if ! command -v xmlstarlet &> /dev/null; then
  install_xmlstarlet
else
  echo "[OK] xmlstarlet found."
fi

# ---- Step 1: Migrate logging configuration in pom.xml ----

POM_FILE="pom.xml"

echo "[INFO] Working on: $(pwd)"

# 1. Remove spring-boot-starter-log4j2
echo "[INFO] Removing spring-boot-starter-log4j2..."
xmlstarlet ed -L \
  -d "//dependency[groupId='org.springframework.boot' and artifactId='spring-boot-starter-log4j2']" \
  "$POM_FILE"

# 2. Remove exclusions for spring-boot-starter-logging
echo "[INFO] Removing exclusions for spring-boot-starter-logging..."
xmlstarlet ed -L \
  -d "//exclusion[groupId='org.springframework.boot' and artifactId='spring-boot-starter-logging']" \
  "$POM_FILE"

# 3. Add spring-boot-starter-logging dependency
echo "[INFO] Adding spring-boot-starter-logging dependency..."
xmlstarlet ed -L \
  -s "/project/dependencies" -t elem -n "dependency" -v "" \
  -s "/project/dependencies/dependency[last()]" -t elem -n "groupId" -v "org.springframework.boot" \
  -s "/project/dependencies/dependency[last()]" -t elem -n "artifactId" -v "spring-boot-starter-logging" \
  "$POM_FILE"

# ---- Step 2: Git commit and push ----

echo "[INFO] Committing changes to Git..."
git add "$POM_FILE"

if git diff --cached --quiet; then
  echo "[SKIP] No changes to commit."
else
  git commit -m "chore(logging): migrate from log4j2 to logback"
  echo "[SUCCESS] Changes committed"
fi

echo "[DONE] Migration complete."

```
