#
# minimal example of how to use docker buildx to get a multi platform image with a little spring
# boot app.
#

PHONY: usage

usage:
	$(info Build the docker image for arm64: > make build-arm-load)
	$(info Run the image:                    > make run-example)



jar:
	mvn package -DskipTests

build: jar
	# For this to work you need to run `docker buildx create --name multi --use` to get a builder setup
    # Docker desktop has everything you need for this to work, on linux server you'll need to
    # configure qemu and a few other things.
	docker buildx build --platform linux/arm64,linux/amd64 --tag spring-demo --load .


build-arm-load: jar
	# For single platform you can load it into image cache.
	docker buildx build --platform linux/arm64 --tag spring-demo --load .
	$(info "Docker image for arm64 loaded into local repo. `docker image ls` to see it.")


buildx-du:
	docker buildx du

buildx-clean:
	docker buildx prune -f

mvn-clean:
	mvn clean


clean: mvn-clean buildx-clean



run-example:
	# See the docker.env for a good way to load env vars
	docker run -p 8080:8080 --env-file docker.env --rm --name spring-demo spring-demo


print-final-flags:
	# Run with the same props and print out final settings... for debuggin.
	docker run --entrypoint java --env-file docker.env --rm --name spring-demo spring-demo -XX:+PrintFlagsFinal -version

