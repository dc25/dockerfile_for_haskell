FROM ubuntu:vivid

RUN mkdir /workarea
WORKDIR /workarea

# Set the locale - was (and may still be ) necessary for ghcjs-boot to work
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

##################################
##### Quick and minimal set ######
##### of developer's tools. ######
##################################
ADD setup_bash_startup /workarea/
RUN ./setup_bash_startup 

ADD install_devl_tools /workarea/
RUN ./install_devl_tools 

ADD setup_sshd /workarea/
RUN ./setup_sshd 

ADD setup_vim_plugins /workarea/
RUN ./setup_vim_plugins 

ADD install_atom /workarea/
RUN ./install_atom 

EXPOSE 22
EXPOSE 8000
ENTRYPOINT ["/usr/bin/svscan", "/services/"]

ADD setup_environment /workarea/

##################################
##### apt-get a collection   #####
##### of utilities that      #####
##### will be needed later   #####
##################################
ADD install_prerequisites /workarea/
RUN ./install_prerequisites 

ADD install_cabal_from_source /workarea/
RUN ./install_cabal_from_source -b cabal-install-v1.22.6.0 

ADD install_alex_and_happy /workarea/
RUN ./install_alex_and_happy 

##################################
##### Install haste.        ######
##### Requires ghc 7.8 so   ######
##### first install ghc 7.8 ######
##### to its own directory. ######
##################################
ADD install_ghc /workarea/
RUN ./install_ghc -v 784 -b ghc-7.8 -p /workarea/ghc784install

ADD install_haste /workarea/
RUN ./install_haste -b 0.5.0

##################################
##### Install ghc 7.10.2 #########
##################################
RUN ./install_ghc -v 710 -b ghc-7.10.2-release

##################################
##### Install some haskell   #####
##### development utilities  #####
##################################
ADD install_haskell_devl_tools /workarea/
RUN ./install_haskell_devl_tools -v 710

ADD setup_stack /workarea/
RUN ./setup_stack -v 710

##################################
##### Install ghcjs ##############
##################################
ADD install_node /workarea/
RUN ./install_node -b v0.12.7-release 

ADD install_ghcjs /workarea/
RUN ./install_ghcjs 

ADD boot_ghcjs /workarea/
RUN ./boot_ghcjs -v 710 

##################################
##### Install typescript     #####
##################################
ADD install_typescript /workarea/
RUN ./install_typescript 

###########################################
#####                                 #####
#####    Personal Customization       #####
#####                                 #####
###########################################
ADD personalize /workarea/
RUN ./personalize
