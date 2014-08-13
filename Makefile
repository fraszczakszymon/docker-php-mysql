project=projectname
http_port=8080
db_port=8086

dependencies:
	@apt-get install docker.io
	@ln -sf /usr/bin/docker.io /usr/local/bin/docker

install: dependencies
	@docker build -t webapp .

run:
	@echo "\033[1;32mApplication info:"
	@echo -n "\033[0;32m   - ID:\t\t\033[1;32m"
	@sudo docker run -p $(http_port):80 -p $(db_port):3306 -v $(CURDIR):/var/www:rw --name $(project) -d webapp /sbin/my_init --enable-insecure-key
	@echo -n "\033[0;32m   - Tag:\t\t\033[1;32m"$(project)"\n"
	@echo -n "\033[0;32m   - IP address:\t\033[1;32m"
	@sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" $(project)
	@echo "\033[0;32m   - Localhost:\t\t\033[1;32mlocalhost:"$(http_port)"\033[0m"
	@echo -n "\033[0;32m   - Running:\t\t\033[1;32m"
	@docker inspect -f "{{ .State.Running }}" $(project)
	@echo "\033[0m"

ssh:
	@./docker/ssh.sh $(project)

status:
	@echo -n "\033[32mApplication is available on:\n\033[0m   - "
	@sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" $(project)
	@echo "   - localhost:"$(http_port)

.PHONY: dependencies install run ssh status