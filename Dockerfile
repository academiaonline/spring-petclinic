################################################################################
#      Copyright (C) 2020        Sebastian Francisco Colomar Bauza             #
#      SPDX-License-Identifier:  GPL-2.0-only                                  #
################################################################################
FROM                                                                           \
  maven:alpine                                                                 \
  AS                                                                           \
  build
ARG                                                                            \
  dir=/dir
ARG                                                                            \
  project=spring-petclinic
WORKDIR                                                                        \
  $dir
COPY                                                                           \
  .                                                                            \
  .
RUN                                                                            \
  mvn install                                                                  \
  &&                                                                           \
  mv target/$project-*.jar $project.jar                                        \
                                                                               ;
################################################################################
FROM                                                                           \
  openjdk:jre-alpine                                                           \
  AS                                                                           \
  production
ARG                                                                            \
  dir=/dir
ARG                                                                            \
  project=spring-petclinic
WORKDIR                                                                        \
  $dir
COPY                                                                           \
  --from=build                                                                 \
  $dir/$project.jar                                                            \
  .
ENTRYPOINT                                                                     \
  ["java","-jar"]
CMD                                                                            \
  ["spring-petclinic.jar"]
################################################################################
