FROM ubuntu:wily

# Build as user "builder" with arbitrary user id.
ENV USER_NAME builder
ENV USER_ID 54840

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

COPY build_scripts/setup_environment $WORKAREA
COPY build_scripts/timestamp $WORKAREA

COPY build_scripts/install_devl_tools $WORKAREA
RUN ./install_devl_tools 

COPY build_scripts/setup_sshd $WORKAREA
RUN ./setup_sshd 

COPY build_scripts/install_cabal_from_source $WORKAREA
RUN ./install_cabal_from_source -b cabal-install-v1.22.6.0 

COPY build_scripts/install_alex_and_happy $WORKAREA
RUN ./install_alex_and_happy 

##########################################################################
##### Install ghc 7.10.3                                             #####
##########################################################################
COPY build_scripts/install_ghc $WORKAREA
RUN ./install_ghc -v 710 -b ghc-7.10.3-release 

##########################################################################
##### Install some haskell development utilities                     #####
##########################################################################
COPY build_scripts/install_haskell_devl_tools $WORKAREA
RUN ./install_haskell_devl_tools -v 710

COPY build_scripts/setup_stack $WORKAREA
RUN ./setup_stack -v 710

##########################################################################
##### Install haste.                                                 #####
##########################################################################
COPY build_scripts/install_haste $WORKAREA
RUN ./install_haste -b 0.5.3

##########################################################################
##### Install ghcjs. Requires a recent version of node so install    #####
##### that first.                                                    #####
##########################################################################
COPY build_scripts/install_node $WORKAREA
RUN ./install_node -b v0.12.7-release 

COPY build_scripts/install_ghcjs $WORKAREA
RUN ./install_ghcjs 

##########################################################################
##### Install typescript                                             #####
##########################################################################
COPY build_scripts/install_typescript $WORKAREA
RUN ./install_typescript

##########################################################################
##### Configure vim for haskell                                      #####
##########################################################################
COPY build_scripts/setup_vim_plugins_for_haskell $WORKAREA
RUN ./setup_vim_plugins_for_haskell 

##########################################################################
##### Install elm                                                    #####
##########################################################################
COPY build_scripts/install_elm $WORKAREA
RUN ./install_elm

##########################################################################
##### Configure vim for elm                                          #####
##########################################################################
COPY build_scripts/setup_vim_plugins_for_elm $WORKAREA
RUN ./setup_vim_plugins_for_elm 

##########################################################################
##### Add in vimrc file with settings for haskell, elm, etc          #####
##########################################################################
COPY build_scripts/vimrc $WORKAREA
RUN cp $WORKAREA/vimrc $HOME/.vimrc

COPY build_scripts/install_devl_tools2 $WORKAREA
RUN ./install_devl_tools2 

RUN mkdir -p $WORKAREA/runtime

COPY build_scripts/runtime/myVimrc            $WORKAREA/runtime/
RUN cp $WORKAREA/runtime/myVimrc $HOME

COPY build_scripts/runtime/startup            $WORKAREA/runtime/
RUN cp $WORKAREA/runtime/startup $HOME

RUN echo ". ~/startup" >> ~/.bashrc

COPY build_scripts/runtime/personalize.sh     $WORKAREA/runtime/
COPY build_scripts/runtime/start.sh           $WORKAREA/runtime/

