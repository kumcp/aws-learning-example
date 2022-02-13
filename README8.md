## Build custom image

-   Choose a random project with a buildable Dockerfile
-   Build with the command line

```
docker build -f Dockerfile.custom-nginx . --tag my-webpage:1
```

-   Try to run in local with:

```
docker run --name webpage -p 8080:80 -d my-webpage:1
```

## Push image to ECR

Before pushing to ECR, you need to get login password

```
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/<public-repo>
```

## Tagging strategy

To tag a local image to a remote image, we can try the command:

```
docker tag <local-image>[:tag] <remote-image>[:tag]

```

-   Tag a specific number first
-   Tag a related version after (like latest, stable, ...)

##
