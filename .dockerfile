
FROM centos:8

# WORKDIR /tmp
RUN uname -a

RUN cat /etc/os-release


# 修改镜像源
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


# 更新系统
RUN yum update -y

# vim
RUN yum install vim -y

# chsh
RUN yum install util-linux-user -y

# git
RUN yum install git -y

# oh-my-zsh
RUN yum install zsh -y
RUN sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
RUN chsh -s /bin/zsh


# nvm
ENV NVM_DIR /root/.nvm
RUN git clone https://github.com/nvm-sh/nvm.git /root/.nvm/
# RUN git checkout v0.39.3
RUN sh ${NVM_DIR}/nvm.sh &&\
	echo '' >> /root/.zshrc &&\
	echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc &&\
	echo '[ -s "${NVM_DIR}/nvm.sh" ] && { source "${NVM_DIR}/nvm.sh" }' >> /root/.zshrc &&\
	echo '[ -s "${NVM_DIR}/bash_completion" ] && { source "${NVM_DIR}/bash_completion" } ' >> /root/.zshrc

# node
RUN dnf module install nodejs:16 -y

# pnpm 
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -


# ruby 
# dnf module list ruby 找最高版本的下载 
RUN dnf module install ruby:3.0 -y
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
#  &&\
# gem install solargraph rubocop rufo
RUN curl https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo
RUN dnf -y install ruby-devel rpm-build make gcc gcc-c++ gcc-gdb-plugin libxml2 libxml2-devel mariadb-devel zlib-devel libxslt-devel

RUN gem install nokogiri -- --use-system-libraries
RUN gem install rails --version="~>7.0"
