Build image:

docker build -t your-ssh-enabled-image .

Run container: 

docker run -d -p 2222:2222 -p 2223:22 your-ssh-enabled-image

Connect ssh:
localhost: 2223

