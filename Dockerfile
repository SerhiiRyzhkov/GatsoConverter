# Use an official OpenJDK 8 runtime as a parent image
FROM openjdk:8-jre

# Install OpenSSH server and other necessary utilities
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    && mkdir /var/run/sshd

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file into the ccdontainer
COPY GSMJ2Convert.jar /app/GSMJ2Convert.jar
COPY evidences /app/MJ2
COPY libGSMediaLib.so /app/libGSMediaLib.so
COPY ffmpeg /app/ffmpeg

# Expose the SSH port and the application port
EXPOSE 22 2222

#Download and install MC
RUN mkdir -p /app/JPG
RUN apt install mc -y
RUN apt install ffmpeg -y

# Create a new user (e.g., 'dockeruser') and set up a password
RUN useradd -m -s /bin/bash dockeruser && echo "dockeruser:password" | chpasswd && adduser dockeruser sudo

# Allow password authentication for SSH
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable bash-completion for interactive shells
RUN echo "source /etc/profile.d/bash_completion.sh" >> /home/dockeruser/.bashrc

# RUN Jar file 
RUN java -jar GSMJ2Convert.jar -src ./MJ2 -dst ./JPG -pwd gatso -jcq 100 -scl 0 -scv 0 -shl 0 -shv 0 -neg 0 -ngv 0 -min 0 -max 4 -dbh 0 -lip 2 -xml 2 -dbv 0 -trg 0 -vmk 1 -vms 5 -vmz 300 -lpi 5 -vmt plus -dbp 1 -avi 1 -mp4 1 -ifr 10 -ofr 10 -vbr 1 -chk off

# Run SSH server and your JAR application
CMD ["/usr/sbin/sshd", "-D"]