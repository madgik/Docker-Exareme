# Exareme with Docker

## Docker Installation

Install Docker (on linux) or Docker-toolbox (on Windows/Mac) 
  - [Mac](https://docs.docker.com/mac/step_one/)
  - [Windows](https://docs.docker.com/windows/step_one/)
  - [Linux](https://docs.docker.com/linux/step_one/)  

Linux only: [Use docker without sudo](http://askubuntu.com/a/477554)

## Exareme Installation
1. Download zip and unzip or “git clone” from Exareme docker repository
  ```bash
  git clone https://github.com/madgik/Docker-Exareme.git
  ```
2. Open a terminal (Docker Quickstart Terminal on Windows/Mac or standard terminal on Linux).
3. Linux only:

  ```bash
  $ sudo service docker start
  ```
4. Navigate to the Exareme Docker Directory:

  ```bash
  $ cd <path to Exareme-Docker>
  ```
5. Build Exareme image (this may take a few minutes the first time):

  ```bash
  $ docker build -t exareme .
  ```


## Run Exareme container
1. If you are planning to use Exareme with the [Stream Server](/StreamServer-Docker)
  1. Run the [Stream Server](/StreamServer-Docker) Container
  2. Run Exareme container (and link to streamserver):
  ```bash
  $ docker run -i -t --rm -p 9090:9090  --link streamserver --name exareme exareme
  ```
  
    ![Alt text](/screenshots/run_exareme.png?raw=true "Run Exareme container and link to Stream Server")
2. To run Exareme only:

  ```bash
  $ docker run -i -t --rm -p 9090:9090  --name exareme exareme
  ```
3. Leave this console open while you are working and then [stop the container](#exit-exareme-container).
4. Find your docker machine IP
  1. On Linux is: localhost
  2. On Windows/Mac open a new Docker Quickstart Terminal and run:
  
    ```
    $ docker-machine ip
    ```
    It will return your docker-machine ip **(from now on use this instead of localhost if you are on Windows or Mac)**.

## Run Stream Queries on Exareme
To run stream queries on Exareme:

1. Run Stream Server container.
2. Run Exareme container (and link with Stream Server container).

### Register a Stream Query

1. Select your favorite REST client. The following screenshots are from [Andvanced REST client](https://chrome.google.com/webstore/detail/hgmloofddffdnphfgcellkdfbfbjeloo) addon from chrome.
2. Open your REST client.
3. To query the Stream Server, as shown below, via Exareme you may register the following query:

  ```sql
  select * from (file dialect:json 'http://streamserver:8989/measurements');
  ```
  
  via a post request at: http://**docker-machine-ip**:9090/streamqueryregister/stream1 with paramter key: register_query and value the query.
  "stream1" is the name of the query you are registering.
  
  ![Alt text](/screenshots/register_stream_query.png?raw=true "Register Stream Query")

###Get Query Results
Get the results of the last 10 seconds by making a GET request at:

```
http://**docker-machine-ip**:9090/streamqueryresult/stream1?last=10
```

![Alt text](/screenshots/get_stream_results.png?raw=true "Register Stream Query")

## Exit Exareme container
To gracefully stop your docker container:

1. Select your Stream Server docker console.
2. Press Ctrl+C.
3. Close the console.
