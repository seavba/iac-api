# <b> Considerations </b>


## Author

<table ><tr><td width=160 ><img src="./images/ssans.png" alt="Sergio Sans" width="150" height="150"></td><td> Hey!! it's me. <br/><br/>This is Sergio Sans, in the past I worked as a Linux and Infrastructure system engineer over 10 years. 3 years ago, I started to work on DevOps branch and I feel really good learning and improving my techie skills every day.<br></td></tr></table>

## Technologies choosen

#### Elixir and Phoenix.

I used Elixir because I have a lot of interest in it, same as Golang, but checking on Internet I found a really nice tutorial for deploying the API application. Also, with Phoenix, I didn't need a webserver and I could use a single container instead of an extra Nginx ECS. So, Elixir won.

#### Github actions as CI/CD

Taking into account my repositories are hosted on Github, I decided to use Github actions as a CI/CD tool.

#### PGSQL / RDS

PostgresSQL DB system, it's the most recommended DB system for Elixir applications. At the same time, based on my experience, it's faster than MySQL and I'm currently working with it in AWS RDS. For this reason, I choosed this combination.

## Security recommendations

- Use HTTPS instead of HTTP.
- Improve Security Groups rules restricting the accesses to the minimum possible level.
- Restrict privileges to RDS master user.
- Use SSL in all the resources
- Use storage_encrypted in RDS
- Use a vault for secrets

## How to scale it

The project is very oriented to scalability and for this reason, it uses an ALB, fargate cluster.

Anyway for ECS containers, the Autoscaling ability can be configured depending on Cloudwatch metrics for making decisions about when to escalate.

Another way to scale this project is using AWS API Gateway. In that case, the availability of the service depends on AWS API Gateway and it can take advantage of using different AWS regions and availability zones.

## Making decisions during project development

I enjoyed a lot developing this project because I learn new things. Initially, I thouhgt how the infrastructure must be. Finally I decided to use ECS and RDS. Once started, I changed to Fargate because I though it was easier for my purposes due to I didn't need to create many different docker applications, only a single one, so it was enough with a Fargate cluster.

About API application, taking into account I never developed an application (besides some plays I did many years ago when I learnt PHP), I decided to use Elixir o Golang in order to learn one of them, and finally I used Elixir because from my point of view (not a developer), it made my life easier.
