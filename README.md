# Learn Infrastructure as Code and CI/CD deployments

I will be creating a very very simple node API which only one route. 
But we will try to deploy it through the CI/CD pipelines and will create our infrastructure with the help of 
terraform.

Our application will run in a Docker container and the container will be stored in the Azure Container Registry.
We will be Azure App Service to get the Proxy URL for our applications so that the internal URL of our application 
is not exposed to the outside world.

PS: I will be heavily dependent on the Gemini for this task. But I will be learning all the concepts that are 
getting used here. Now just copy pasting blindly. This is the best way of learning I guess. You can see the outputs 
and then you try to figure out why it worked going inside deeply.