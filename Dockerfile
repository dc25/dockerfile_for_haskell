FROM ubuntu:wily

# Build as user ghc with "random" user id.
ENV USER_NAME ghc
ENV USER_ID 54836

# Set the locale - was (and may still be ) necessary for ghcjs-boot to work
# Got this originally here: # http://askubuntu.com/questions/581458/how-to-configure-locales-to-unicode-in-a-docker-ubuntu-14-04-container
#
# 2015-10-25 It seems like ghcjs-boot works without this now but when I 
# removed it, vim starting emitting error messages when using plugins 
# pathogen and vim2hs together.  
#
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Create a new user, to do the rest of the build.
RUN apt-get install -y sudo
RUN adduser --disabled-password --gecos '' --uid $USER_ID $USER_NAME
RUN adduser $USER_NAME sudo 
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER_NAME

ENV WORKAREA /home/$USER_NAME/workarea/
RUN mkdir -p $WORKAREA
WORKDIR $WORKAREA

COPY setup_environment $WORKAREA
COPY timestamp $WORKAREA

COPY install_devl_tools $WORKAREA
RUN ./install_devl_tools 

COPY setup_sshd $WORKAREA
RUN ./setup_sshd 

COPY install_cabal_from_source $WORKAREA
RUN ./install_cabal_from_source -b cabal-install-v1.22.6.0 

COPY install_alex_and_happy $WORKAREA
RUN ./install_alex_and_happy 

##########################################################################
##### Install ghc 7.10.2                                             #####
##########################################################################
COPY install_ghc $WORKAREA
RUN ./install_ghc -v 710 -b ghc-7.10.2-release 

##########################################################################
##### Install some haskell development utilities                     #####
##########################################################################
COPY install_haskell_devl_tools $WORKAREA
RUN ./install_haskell_devl_tools -v 710

COPY setup_stack $WORKAREA
RUN ./setup_stack -v 710

##########################################################################
##### Install haste.                                                 #####
##########################################################################
COPY install_haste $WORKAREA
RUN ./install_haste -b 0.5.2

##########################################################################
##### Install ghcjs. Requires a recent version of node so install    #####
##### that first.                                                    #####
##########################################################################
COPY install_node $WORKAREA
RUN ./install_node -b v0.12.7-release 

COPY install_ghcjs $WORKAREA
RUN ./install_ghcjs 

##########################################################################
##### Install typescript                                             #####
##########################################################################
COPY install_typescript $WORKAREA
RUN ./install_typescript

COPY setup_vim_plugins $WORKAREA
RUN ./setup_vim_plugins 

COPY vimrc $WORKAREA
RUN cp $WORKAREA/vimrc $HOME/.vimrc
