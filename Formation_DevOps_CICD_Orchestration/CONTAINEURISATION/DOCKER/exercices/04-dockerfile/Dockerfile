# 1. Image de base (ingrédient principal)
FROM python:3.11-slim

# 2. Métadonnées
LABEL maintainer="devops@example.com"
LABEL version="1.0"

# 3. Définir le répertoire de travail
WORKDIR /app

# 4. Copier les dépendances (optimisation cache)
COPY requirements.txt .

# 5. Installer les dépendances
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copier le code de l'application
COPY app.py .

# 7. Créer un utilisateur non-root (sécurité)
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# 8. Passer à l'utilisateur non-root
USER appuser

# 9. Exposer le port
EXPOSE 5000

# 10. Commande de démarrage
CMD ["python", "app.py"]
