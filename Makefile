SHELL:=/bin/bash
CONTAINER_NAME = "lucee-docker-dev"
REPOSITORY = "hipipe/$(CONTAINER_NAME)"

.PHONY: build run exec

all: build run exec

build:
	@echo "Building container $(REPOSITORY)"

	docker build -t "$(REPOSITORY):latest" --pull .

run:
	@echo "Run container $(CONTAINER_NAME)"

	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)
	docker run -d \
    	--name $(CONTAINER_NAME) \
		-P \
    	--restart=always \
    	$(REPOSITORY)

exec:
	docker exec -it $(CONTAINER_NAME) /bin/bash