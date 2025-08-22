# Comet - Simple Application Deployment

Welcome! This guide will help you deploy a web application to your computer or cloud. No technical expertise required!

## 🚀 What This Does

This project automatically:

- Builds a web application
- Packages everything needed to run it
- Deploys it to your chosen location
- Tests that everything works correctly

## 📋 What You Need

Before you start, make sure you have these installed on your computer:

### Required Software

- **Docker Desktop** - [Download here](https://www.docker.com/products/docker-desktop/)
- **Minikube** - [Download here](https://minikube.sigs.k8s.io/docs/start/)

### Optional (for cloud deployment)

- **Terraform** - [Download here](https://www.terraform.io/downloads)

## 🏠 Option 1: Run Locally (Easiest)

### Step 1: Start Your Local Environment

Open a terminal and run:

```bash
minikube start
```

Wait for it to finish (you'll see "Done!" when ready).

### Step 2: Set Up Docker

In the same terminal, run:

```bash
eval $(minikube docker-env)
```

### Step 3: Build Your Application

```bash
docker build -t hello-world-app:latest ./app
```

### Step 4: Deploy the Application

```bash
helm install hello-world ./charts/hello-world
```

### Step 5: Access Your Application

```bash
kubectl port-forward svc/hello-world 8080:8080
```

**Keep this terminal open!** Then open your web browser and go to:
**http://localhost:8080**

You should see a message like:

```json
{
  "message": "Hello World from Go!",
  "timestamp": "2025-08-22T03:05:41.845497666Z",
  "hostname": "hello-world-...",
  "version": "1.0.0"
}
```

### Step 6: Stop When Done

When you're finished, press `Ctrl+C` in the terminal running port-forward, then:

```bash
helm uninstall hello-world
minikube stop
```

## ☁️ Option 2: Deploy to Cloud (Advanced)

### DigitalOcean (Recommended for beginners)

1. **Get a DigitalOcean account** at [digitalocean.com](https://digitalocean.com)
2. **Create an API token** in your DigitalOcean dashboard
3. **Add the token to GitHub** (see "Setting Up Secrets" below)
4. **Push your code** to GitHub - it will deploy automatically!

### AWS (For experienced users)

1. **Get an AWS account** at [aws.amazon.com](https://aws.amazon.com)
2. **Create access keys** in your AWS dashboard
3. **Add the keys to GitHub** (see "Setting Up Secrets" below)
4. **Push your code** to GitHub - it will deploy automatically!

## 🔐 Setting Up Secrets (Cloud Deployment)

If you want to deploy to the cloud, you need to add some secret information to GitHub:

### For DigitalOcean:

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `DO_TOKEN`
5. Value: Your DigitalOcean API token
6. Click **Add secret**

### For AWS:

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:
   - `AWS_ACCESS_KEY_ID` - Your AWS access key
   - `AWS_SECRET_ACCESS_KEY` - Your AWS secret key
   - `AWS_REGION` - Your preferred region (e.g., `us-west-2`)

## 🧪 Testing Your Deployment

### Check if everything is running:

```bash
kubectl get pods
```

You should see pods with status "Running".

### Check your application:

```bash
curl http://localhost:8080
```

### Check the health endpoint:

```bash
curl http://localhost:8080/health
```

## 🆘 Troubleshooting

### "Port 8080 is already in use"

Try a different port:

```bash
kubectl port-forward svc/hello-world 8081:8080
```

Then visit http://localhost:8081

### "Minikube failed to start"

Try:

```bash
minikube delete
minikube start
```

### "Docker build failed"

Make sure Docker Desktop is running and try again.

### "Helm command not found"

Install Helm:

- **Windows/Mac**: `choco install kubernetes-helm` or `brew install helm`
- **Linux**: `sudo apt-get install helm` or equivalent

## 📱 What You Get

After successful deployment, you'll have:

- ✅ A web application running on your computer or cloud
- ✅ Automatic health checks
- ✅ Redis database for storing data
- ✅ Everything packaged and ready to use

## 🔄 Making Changes

Want to modify the application?

1. **Edit the code** in `app/main.go`
2. **Rebuild the image**:
   ```bash
   docker build -t hello-world-app:latest ./app
   ```
3. **Update the deployment**:
   ```bash
   helm upgrade hello-world ./charts/hello-world
   ```

## 📞 Need Help?

- **Check the logs**: `kubectl logs -l app.kubernetes.io/name=hello-world`
- **Restart everything**: `helm uninstall hello-world && helm install hello-world ./charts/hello-world`
- **Start fresh**: `minikube delete && minikube start`

## 🎯 What's Happening Behind the Scenes

Don't worry about these details, but here's what the system does automatically:

1. **Builds** your application into a container
2. **Packages** everything needed to run it
3. **Deploys** to your chosen environment
4. **Tests** that everything works
5. **Monitors** the health of your application

## 🏁 Congratulations!

You've successfully deployed a modern web application! This same process is used by companies worldwide to deploy applications to production environments.

---

**Remember**: The local deployment is perfect for testing and development. Use cloud deployment when you're ready to share your application with others!
