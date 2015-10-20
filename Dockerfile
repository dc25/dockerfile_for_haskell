FROM ubuntu:vivid

# Just a dummy to change to force rebuilding.
ENV DOCKER_BUILD 9

RUN mkdir /workarea
WORKDIR /workarea

# Set the locale - was (and may still be ) necessary for ghcjs-boot to work
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

COPY setup_environment /workarea/
COPY timestamp /workarea/

COPY install_devl_tools /workarea/
RUN ./install_devl_tools 

COPY setup_sshd /workarea/
RUN ./setup_sshd 

EXPOSE 22
EXPOSE 8000
ENTRYPOINT ["/usr/bin/svscan", "/services/"]

COPY setup_user /workarea/
RUN ./setup_user dave 1000

USER dave

COPY install_cabal_from_source /workarea/
RUN ./install_cabal_from_source -b cabal-install-v1.22.6.0 

COPY install_alex_and_happy /workarea/
RUN ./install_alex_and_happy 

##########################################################################
##### Install ghc 7.10.2                                             #####
##########################################################################
COPY install_ghc /workarea/
RUN ./install_ghc -v 710 -b ghc-7.10.2-release 

##########################################################################
##### Install some haskell development utilities                     #####
##########################################################################
COPY install_haskell_devl_tools /workarea/
RUN ./install_haskell_devl_tools -v 710

COPY setup_stack /workarea/
RUN ./setup_stack -v 710

##########################################################################
##### Install haste.                                                 #####
##########################################################################
COPY install_haste /workarea/
RUN ./install_haste -b 0.5.2

##########################################################################
##### Install ghcjs. Requires a recent version of node so install    #####
##### that first.                                                    #####
##########################################################################
COPY install_node /workarea/
RUN ./install_node -b v0.12.7-release 

COPY install_ghcjs /workarea/
RUN ./install_ghcjs 

COPY boot_ghcjs /workarea/
RUN ./boot_ghcjs -v 710 

##########################################################################
##### Install typescript                                             #####
##########################################################################
COPY install_typescript /workarea/
RUN ./install_typescript

COPY setup_bash_startup /workarea/
RUN ./setup_bash_startup 

COPY setup_vim_plugins /workarea/
RUN ./setup_vim_plugins 

COPY personalize /workarea/
RUN ./personalize

USER root
