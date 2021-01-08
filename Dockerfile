################################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza             #
#      SPDX-License-Identifier:  GPL-2.0-only                                  #
################################################################################
ARG                                                                            \
  digest="@sha256:7445f83cd169b9f0b185e443e755ece1e37d3cf1e2e90f9180afad2fdb9d2bc4"
ARG                                                                            \
  image="maven"
ARG                                                                            \
  tag="3.6.1-jdk-8-alpine"
################################################################################
FROM                                                                           \
  #${image}:${tag}${digest}                                                     \
  ${image}:${tag}                                                              \
  #maven:3.6.1-jdk-8-alpine@sha256:7445f83cd169b9f0b185e443e755ece1e37d3cf1e2e90f9180afad2fdb9d2bc4 \
  #maven:3.6.1-jdk-8-alpine \
  AS                                                                           \
  build
################################################################################
ARG                                                                            \
  dir=/build
WORKDIR                                                                        \
  $dir
COPY                                                                           \
  .                                                                            \
  .
RUN                                                                            \
  mvn install                                                                  \
  &&                                                                           \
  mv target/*.jar java.jar                                                     \
                                                                               ;
################################################################################
ARG                                                                            \
  digest=@sha256:4da3b2460418a3d7bd9b4b6ee51951d5a6fdede28298c0a0106aa69dbac3937e
ARG                                                                            \
  image=openjdk
ARG                                                                            \
  tag=jre-alpine3.8
################################################################################
FROM                                                                           \
  ${image}:${tag}${digest}                                                     \
  #openjdk:jre-alpine3.8@sha256:4da3b2460418a3d7bd9b4b6ee51951d5a6fdede28298c0a0106aa69dbac3937e \
  AS                                                                           \
  production
################################################################################
ARG                                                                            \
  build_dir=/build
ARG                                                                            \
  dir=/app
WORKDIR                                                                        \
  $dir
COPY                                                                           \
  --from=build                                                                 \
  $build_dir/java.jar                                                          \
  .
ENTRYPOINT                                                                     \
  ["java","-jar"]
CMD                                                                            \
  ["java.jar"]
################################################################################
