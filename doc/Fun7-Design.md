# I. Project
Mobile multiplayer game “Fun7” is used all over the world. To achieve the best connectivity across the globe, the game has backend infrastructure deployed in 3 continents: North America, Europe and Asia

In order for the game to know which backend to connect to, it performs a
connectivity check to each of 3 backends on the list and chooses the one with the lowest latency.

Connectivity test is invoked from the game to the HTTP connectivity test server (CTS).

Connectivity test is a simple HTTP GET request:

```
Request:
GET /ping

Response:
200 OK
```

Game measures the request+response latency and then chooses the server with
the lowest latency.

Your assignment is to design and implement a simple connectivity test backend
server (together with CI/CD) using the most appropriate agile principles.
Specifically:
1. Write a simple CTS backend application.
2. Every git commit should automatically trigger an application build.
3. Describe how you would set up infrastructure to be resilient to failures of compute nodes and scale automatically in case of increased CPU. You can
also provide configuration files for the infrastructure/tools you would use.
4. Every merge/commit to master should also automatically deploy a new
version of CTS.

Requirements:
1. Solution should be hosted on github/bitbucket. Please send us a link to the
solution.
2. CTS should be written in any appropriate language and Dockerized.
3. Feel free to implement CI/CD pipeline with the tool of your choice (Jenkins,
CircleCI, Travis CI ...).
4. Your solution should leverage Google Cloud. You can also use IaC.
5. Make sure that your solution is production ready so apply all the techniques
that you would normally do when writing code in a real life situation.
6. Please provide a README file with the description on how to build your
application and how to run, test and deploy it.



# II. Project Design
We can identify 2 components, the client-side application F7 and the server-side CTS endpoints. As to separate concerns, 2 code repositories are necessary.
- The F7-app is the client-side application to develop, build, and deploy. It is then served to be downloaded by arbitrary many clients. As per tasks, the development itself is not relevant, but it must integrate within the overall architecture.
- The CTS backend is a node system for latency checks accross different countries. It is the software to write, build, test and deploy.

### Backend programming language
The CTS-App will be deployed using a backend programming language.
To build qualitative software, we review performances and license rights for several popular choices.

#### Performances 
| Language (Framework) | Time-performance° | Container                    | Space-Performance°° |
| -------------------- | ----------------- | ---------------------------- | ------------------- |
| Rust (Actix)         | 171484            | rust:latest                  | 519.57 MB           |
| C# (ASP.net)         | 144304            | °°°                          | °°°                 |
| Go (Fiber)           | 116952            | fernapi/fern-go-fiber:latest | 288.93 MB           |
| Node (Express)       | 33868             | node:latest                  | 385.61 MB           |

° Performances following [1]\
°° Compressed size of container image as proposed in [2, 3, 4, 5].\
°°° ASP.net depends on a multitude of containers (SDK, ASPNet, Runtime, Runtime-dep).


**Summary**\
The benchmark is based on TechEmpower's Fortunes Testing (https://github.com/TechEmpower/FrameworkBenchmarks/wiki/Project-Information-Framework-Tests-Overview#fortunes) which is impartial irrelevant to a simple CTS-Backend.
Further reading shows that Actix places first in the latest Fortunes benchmark, #9 in JSON serialization, #2 in single database query requests, #3 in multiple database query request, #2 in database updates, and #7 in plaintext requests.
It is safe to assume that simple HTTP Responses will be of equally qualitative performance.
However, the deployed Rust container has a memory requirement of roughly 1.8GB. 
If storage is of inconvenience, it may be adivsable to create a secondary build based on Golang, with unpacked container image memory usage of 837 MB.

**References**
- [1] Best Popular Backend Frameworks by Performance Benchmark Comparison and Ranking in 2024: https://dev.to/tuananhpham/popular-backend-frameworks-performance-benchmark-1bkh
- [2] Dockerhub (Rust): https://hub.docker.com/_/rust/tags
- [3] Dockerhub (ASP.net): https://hub.docker.com/r/microsoft/dotnet-aspnet/tags
- [4] Dockerhub (Go): https://hub.docker.com/_/golang/tags
- [5] Dockerhub (Node): https://hub.docker.com/_/node/tags


#### Use-rights and licenses
| Reference | Language | Framework | Licensing                 |
| --------- | -------- | --------- | ------------------------- |
| [6]       | Rust     | Actix     | MIT, Apache2              |
| [7]       | C#       | ASP.net   | MIT                       |
| [8]       | Go       | Fiber     | BSD-3-Clause license, MIT |
| [9]       | Node     | Express   | Custom, MIT               |

**Summary**\
Most of the reviewed languages and frameworks are eligible for commercial use. There are no conflicts in regards to fair software use as business.

**References**
- [6] https://github.com/actix/actix-web
- [7] https://github.com/microsoft/dotnet/blob/main/LICENSE
- [8] https://github.com/gofiber/fiber?tab=MIT-1-ov-file
- [9] https://github.com/nodejs/node/tree/main?tab=License-1-ov-file#readme 

### CI/CD
1. **Continuous integration**: Regards local code development and building. The software must compile successfully in acceptable time.
2. **Continuous delivery**: After stage 1, the application will be tested on the developer-local device.
We check whether the code as a whole is eligible to be committed to the code repositories using Git-Hooks, by building and running containers, analysing the code for secrets and vulnerabilities (SCA, SAST, DAST)
3. **Continuous deployment**: Software pushed to the code repository will undergo a infrastructure test within the development environment. If that check is successfull, the code may be forwarded to the master-branch of the repository. If this branch is updated, a new software version is built and deployed to the official download section.
4. **Continuous feedback**: Resources could be spend to monitor the worker nodes. Alerts, warnings and errors can be mailed to technical administration. Feedback from th perspective of F7 can be collected via users and their devices, per opt-in/opt-out decision, particularly crash reports.


| Criteria | CircleCI | Jenkins | Travis |
| --- | --- | --- | --- |
| License | Paid License | **MIT License** | Paid License |
| Open-Source | No | **Yes** | No |
| Hosting | On premise/Cloud | On premise/Cloud | On premise/Cloud |
| Supported OS | Linux, MacOs | Windows, Linux, MacOs | Linux, MacOs |
| Free Version | Limited | **Available** | Limited |


Jenkins appears to be an optimal solution.
Given that there is not enough time left to complete the challenge at this point (Deadline in 6 hours), CircleCI will be used.


### Cloud and container orchestration
To orchestrate containers, we utilize Docker as container engine.
This can extend to Kubernetes, to distribute container runtimes accross a given network architecture.
Cloud provisioning can be utilized via Cloud service providers which offer Kubernetes interfaces, including AWS, Microsoft and Google.

Given the requirement of leveraging Google Cloud, the Google kubernetes engine will be used.

#### Worker node failure resilience
1. Optimizing node stability
    - Node taint toleration (node.kubernetes.io)
2. Optimizing pod stability
    - Using the configuration 'pod-eviction-timeout' to handle disruptions gracefully.
3. Disaster Recovery 
    - TODO
4. Failure simulation during testing
    - TODO
5. Monitoring using Prometheus (Google Cloud Managed Service)
    - TODO
6. Zone-specific scaling of services
    - TODO

#### Worker node scaling
- Horizontal scaling: Horizontal scaling is adding additional pods to the node.
- Vertical scaling: Vertical scaling is adding ressources to a singular node or pod.

Optimally, we scale horizontal depending on expansion to new zonal areas. Vertical scaling makes sense 
where more performance is required -- depending on population density, time and clust cost.


# III. Implementation
- Programming language: 
  - Rust using Actix.
- CI/CD:
  - Local build and test: Git hooks, Docker tests
  - Remote build and test: CircleCI
  - Deploy: Software deployment as docker image
- Orchestration:
  - Docker: Custom Image
  - Google Kubernetes Engine: Container deployment and orchestration

# IV. Task identification
Following the project statements and it's requirements:

- [X] Project deployment in one week (29.08.24 16:00 UTC+2 - 05.08.24 16:00 UTC+2) 
- [ ] Production-ready solution
- [X] Agile-compliant DevOps
- [X] Development of a CTS backend
    - [X] CTS written in any appropriate language: **Rust (Actix)**
    - [X] Dockerize the CTS app: **Dockerfile**
    - [X] Automated application build on git commit: **Git hooks**
- [X] Hosted on VCS-Server
    - [X] CI/CD pipeline: **CircleCI**
    - [X] New version build on git push: **CircleCI via Dockerhub**
- [ ] Leverage Google Cloud or IaC: **Google Cloud: GKE + GCR**
    - [ ] Automated scaling of compute nodes
    - [ ] Fail-safety of compute nodes
- [X] Provide README with all necessary steps for software execution

See [Post-Mortem](./Post-Mortem.md) for post-submission review.

References:
- Github.com: https://github.com/ThompsonA93/CTS-Backend
- CircleCi.com: https://app.circleci.com/pipelines/github/ThompsonA93/CTS-Backend 
- Crates.io: https://crates.io/crates/f7-cts-backend 
- Dockerhub.com: https://hub.docker.com/repository/docker/thompsona93/cts-backend/general 