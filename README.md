# Melita DevOps Technical Test

This project is a Technical Test which involves 2 tasks. The first task in constructed around the Google Cloud, whilst the second task is to build a bash script application.  

# Task 1 

## Synoptic
This task involved creating a containerised Wordpress instance, which uses Google Cloud services to function. This Wordpress instance also required to contain an SSL key, by the provider 'Let's Encrypt'.  A break down of these services areas following 

- **Google Cloud Kubernetes** 
- **Google Cloud SQL**
- **Google Cloud Storage**
- **SSL Offloading 'Let's Encrypt'**

Inside this README.d, I will discuses the decisions  and step I have taken to complete the tasks for this DevOps Technical Test

All the following services have been created within the namespace `default`

For this project, I have **not** cleaned up credentials and other information within credentials, for your own viewing. 

## Google Cloud SQL 

### IAM Permissions
The first step to create a connection for the Wordpress Instance is to create an **IAM Permission** as an 'Cloud SQL Client' 

Cloud SQL Member:

    wordpress-melita-test-service@quantum-pilot-287118.iam.gserviceaccount.com

After the member has been created, it is important to create the credentials as a **JSON format**, in order to create a secret within Google Kubernetes. 

The JSON credentials for this Cloud SQL Member may be found within **./wordpress/** 

After this has been completed, the next step would be to create a secret which contain the following parameters `username, connectionName, password`. These are required when creating the service within Kubernetes.

DB credentials secret described

    wordpress-cloudsql-db-credentials
    
    
    Name:         wordpress-cloudsql-db-credentials
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>
    Type:  Opaque
    Data
    ====
    username:        21 bytes
    connectionName:  55 bytes
    password:        24 bytes

JSON credentials secret described 

    cloudsql-instance-credentials
    
    Name:         cloudsql-instance-credentials
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>
    Type:  Opaque
    Data
    ====
    credentials.json:  2374 bytes

## Creating Services 

For this task, I have chosen to create two types of the services, the first being a **'StatefulSets'** and the second being a **'Service'.** 
This StatefulSet shall be hosting wordpress internally, whilst the 'Service' shall be providing wordpress externally from the StatefulSet. This 'Service' shall be known as an 'Load Balancer'.
You may find the .yaml of this creation within **`./wordpress/`** 

## Creating Ingress 

For this task an Nignx Ingress was created which forwards ports : `80, 443` from the 'Service' (Load Balancer) mentioned in the pervious section 'Creating Services'.
You may find the .yaml of this creation within **`./wordpress/`** 

### Creating Ingress SSL Certificate 'Let's Encrypt' 

When creating this NGINX Ingress Controller, the tool `helm`  was used. There were 2 different keys created when applying these certificates `letsencrypt-staging` & `letsencrypt-prod`. 
`letsencrypt-staging` is being used for the NGINX Ingress 

letsencrpt-staging
   

    Name:         letsencrypt-staging
    Namespace:    default
    Labels:       <none>
    Annotations:  API Version:  cert-manager.io/v1beta1
    Kind:         Issuer
    Metadata:
      Creation Timestamp:  2020-08-23T22:37:59Z
      Generation:          1
      Resource Version:    404015
      Self Link:           /apis/cert-manager.io/v1beta1/namespaces/default/issuers/letsencrypt-staging
      UID:                 32c34e18-bd77-4c05-93b4-9cef565323b9
    Spec:
      Acme:
        Email:  melitatest082020@gmail.com
        Private Key Secret Ref:
          Name:  letsencrypt-staging
        Server:  https://acme-staging-v02.api.letsencrypt.org/directory
        Solvers:
          http01:
            Ingress:
              Class:  nginx
    Status:
      Acme:
        Last Registered Email:  melitatest082020@gmail.com
        Uri:                    https://acme-staging-v02.api.letsencrypt.org/acme/acct/15297096
      Conditions:
        Last Transition Time:  2020-08-23T22:38:00Z
        Message:               The ACME account was registered with the ACME server
        Reason:                ACMEAccountRegistered
        Status:                True
        Type:                  Ready
    Events:                    <none>

letsencrpt-prod

    Name:         letsencrypt-prod
    Namespace:    default
    Labels:       <none>
    Annotations:  API Version:  cert-manager.io/v1beta1
    Kind:         Issuer
    Metadata:
      Creation Timestamp:  2020-08-23T22:38:08Z
      Generation:          1
      Resource Version:    404060
      Self Link:           /apis/cert-manager.io/v1beta1/namespaces/default/issuers/letsencrypt-prod
      UID:                 f0b6611d-181a-43eb-8ac3-be22cefeefa5
    Spec:
      Acme:
        Email:  melita082020@gmail.com
        Private Key Secret Ref:
          Name:  letsencrypt-prod
        Server:  https://acme-v02.api.letsencrypt.org/directory
        Solvers:
          http01:
            Ingress:
              Class:  nginx
    Status:
      Acme:
        Last Registered Email:  melita082020@gmail.com
        Uri:                    https://acme-v02.api.letsencrypt.org/acme/acct/94700742
      Conditions:
        Last Transition Time:  2020-08-23T22:38:09Z
        Message:               The ACME account was registered with the ACME server
        Reason:                ACMEAccountRegistered
        Status:                True
        Type:                  Ready
    Events:                    <none>

## Google Cloud Storage Bucket

As this project requires a StatefulSet to be created, there are 2 possible routes to link a wordpress instance to a Google Bucket. The first being by creating an 'NFS' connection. Whilst the second is by creating a Stateless Wordpress. I personally feel there are quite a number of risks when creating an 'NFS' connection as it opens another connection which could be vulnerable for an attack. 
The NFS connection will have to be created within Kubernetes and Google Cloud
The second option would be to create a Stateless Wordpress instance. This means no new connections will have to be opened. 

### Creating Bucket 
When creating the Bucket, the permissions `'AllUsers'` have be given in order to open the Wordpress instance to the public.  

### Stateless Wordpress
The Stateless Wordpress is an **Industry Standard** plugin which connections Wordpress to Google Cloud Bucket. 

[https://wordpress.org/plugins/wp-stateless/](/Melita-Test-Wordpress-Google-Bucket)

## Url's 
Ingress : [http://34.95.115.70/](http://34.95.115.70/)
Load Balancer : [http://34.77.227.44/](http://34.77.227.44/)


# Task 2 

## Synoptic

This task involves 

 - Checking File Age
   - copy command after file/s are older than 1 day
   - compress command after file/s are older than 7 days

## Bash file application 

This bash file maybe found within this project **./task2/**



# Issues 

The only issue I came across was when I applied the SSL Certificate to the Ingress

    Could not find TLS certificates. Continuing setup for the load balancer to serve HTTP. Note: this behavior is deprecated and will be removed in a future version of ingress-gce

## Conclusion   

I would like to simply say thank you for your time to look into this project and consider me for this position. 
I always feel we are learning in life, so I welcome any sort of feedback and criticism to gain further knowledge and insight :) 