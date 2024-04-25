FROM python:3.9-slim as builder
WORKDIR /app  
RUN pip install flask==2.3.2 flask_sqlalchemy==3.0.5 flask_bcrypt==1.0.1 flask_login==0.6.2 flask_wtf==1.1.1 email_validator==2.0.0.post2  --upgrade pip tensorflow==2.13.0 Pillow==9.0.1 Werkzeug==2.3.7
COPY . .
#this is the nase image that will run on container
FROM python:3.9-slim
WORKDIR /app
# Copy installed Python environments from builder
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
# Copy the built application from the builder stage to the final stage
COPY --from=builder /app /app
# Expose the port the app runs on
EXPOSE 5000
# Set the command to run your app (e.g., Flask)
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
