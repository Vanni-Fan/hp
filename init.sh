#!/bin/bash

#{{{ 创建目录
mkdir -p /hp/man/{man1,man2,man3,man4,man5,man6,man7,man8,man9}
mkdir -p /hp/{etc/ld.so.conf.d,data,log,bin,sbin,projects,opt,include}
#}}}

#{{{ 生成 /hp/etc/hp.profile 文件
cat > /hp/etc/hp.profile <<'OK_OEF'
pathmunge(){
    if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)"; then
        if [ "$2" = "after" ]; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi  
    fi  
    export PATH
}

pathmunge /hp/sbin
pathmunge /hp/bin

for d in `find /hp/projects/ -name 'bin' -type d 2>/dev/null`;
do
    pathmunge $d
done;

EDITOR=/usr/bin/vim
SVN_EDITOR=$EDITOR


# for man color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# for ls color
LS_COLORS='no=00:fi=00:di=01;96:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42
:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:';
export LS_COLORS

# for cd word error
shopt -s cdspell

# Multi-line commands to merge into one line
shopt -s cmdhist

# for grep color
alias grep='grep --color'
OK_OEF

#}}}

#{{{ 生成 /hp/etc/hp.bashrc 文件
cat > /hp/etc/hp.bashrc <<'OK_OEF'
pathmunge(){
    if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)"; then
        if [ "$2" = "after" ]; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi  
    fi  
    export PATH
}

pathmunge /hp/sbin
pathmunge /hp/bin

for d in `find /hp/projects/ -name 'bin' -type d 2>/dev/null`;
do
    pathmunge $d
done;

EDITOR=/usr/bin/vim
SVN_EDITOR=$EDITOR


# for man color
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# for ls color
LS_COLORS='no=00:fi=00:di=01;96:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42
:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:';
export LS_COLORS

# for cd word error
shopt -s cdspell

# Multi-line commands to merge into one line
shopt -s cmdhist

# for grep color
alias grep='grep --color'
OK_OEF

#}}}

#{{{ 生成 /hp/bin/hplink 文件
cat > /hp/bin/hplink <<'OK_OEF'
#!/usr/bin/env bash
# Author: Vanni
# Usage: hplink TYPE DIRECTORY
# Create/update or delete soft-link to hp path for build or remove project.
# TYPE: create, delete, update  
# Ex:  hplink create /hp/opt/mysql
# Ex:  hplink update /hp/opt/mysql 
# Ex:  hplink delete /hp/opt/mysql

if [[ -z "$1" || -z "$2" ]]; then
    echo Usage: hplink TYPE DIRECTORY
    echo Create/update or delete soft-link to hp path for build or remove project.
    echo TYPE: create, delete, update  
    echo Ex:  hplink create /hp/opt/mysql
    echo Ex:  hplink update /hp/opt/mysql 
    echo Ex:  hplink delete /hp/opt/mysql
    exit 0
fi
ALL_TYPE='create update delete'

if [[ ! -a $2 ]]; then
    echo "$2 not exists"
    exit 0
fi

OPT_TYPE=$1                 # 操作类型
SOFT_PATH=$(cd $2;pwd)      # 传入的软件安装路径
SOFT_NAME=${SOFT_PATH##*/}  # 传入的软件名称

NEED_LDCONFIG=0             # 需要调用 ldconfig 

_MATCH=${ALL_TYPE/"$OPT_TYPE"/""}
if [[ "$_MATCH" == "$ALL_TYPE" ]]; then
    echo The TYPE not matched. TYPE must be 'create' 'update' or  'delete'.
    exit 0
fi

#echo find $SOFT_PATH -name bin -or -name sbin -or -name "man[1-9]" -or -name etc -or -name conf -or -name config
ALL_FILE=`find $SOFT_PATH -name bin -or -name sbin -or -name "man[1-9]" -or -name etc -or -name conf -or -name config -or -name lib -or -name library -or -name libraries -or -name include`
for FILE_PATH in $ALL_FILE; do
    #echo $FILE_PATH
    # 获得类型
    _TYPE=${FILE_PATH##*/}
    case $_TYPE in
        'lib' | 'library' | 'libraries')
            NEED_LDCONFIG=1
            # /etc/ld.so.conf.d/hp/* 处理添加文件
            LD_FILE="/etc/ld.so.conf.d/hp/$SOFT_NAME"
            case $OPT_TYPE in
                'create' | 'update')
                    if [[ ! -e $LD_FILE ]]; then


                        echo "$FILE_PATH" > $LD_FILE   # 创建文件
                    else
                        echo "$FILE_PATH" >> $LD_FILE  # 追加记录
                    fi
                ;;
                'delete')
                    rm -f $LD_FILE
                ;;
            esac
        ;;
        'include')
            # /usr/include/hp/* 处理软链接
            LINK_NAME="/usr/include/hp/$SOFT_NAME"
            case $OPT_TYPE in
                'create')
                    if [[ ! -e $LINK_NAME ]]; then
                        #echo ln -s $FILE_PATH $LINK_NAME
                        ln -s $FILE_PATH $LINK_NAME
                    else
                        echo "Link $LINK_NAME exists, link to `pwd $LINK_NAME`."
                    fi
                ;;
                'update')
                    #echo ln -s $FILE_PATH $LINK_NAME
                    [[ -L $LINK_NAME ]] || ln -s $FILE_PATH $LINK_NAME
                ;;
                'delete')
                    #echo unlink $LINK_NAME
                    [[ -L $LINK_NAME ]] && unlink $LINK_NAME
                ;;
            esac
        ;;
        'config'|'conf'|'etc')  # 创建项目子目录 
            LINK_NAME="/hp/etc/$SOFT_NAME"
            case $OPT_TYPE in
                'create')
                    if [[ ! -e $LINK_NAME ]]; then
                        #echo ln -s $FILE_PATH $LINK_NAME
                        ln -s $FILE_PATH $LINK_NAME
                    else
                        echo "Link $LINK_NAME exists, link to `pwd $LINK_NAME`."
                    fi
                ;;
                'update')
                    #echo ln -s $FILE_PATH $LINK_NAME
                    [[ -L $LINK_NAME ]] || ln -s $FILE_PATH $LINK_NAME
                ;;
                'delete')
                    #echo unlink $LINK_NAME
                    [[ -L $LINK_NAME ]] && unlink $LINK_NAME
                ;;
            esac
        ;;
        'bin' | 'sbin' | man* )
            for _FILE in $FILE_PATH/*; do
                #echo $_FILE
                if [[ ${_TYPE:0:3} == "man" ]]; then
                    LINK_NAME="/hp/man/$_TYPE/"${_FILE##*/}
                else
                    LINK_NAME="/hp/$_TYPE/"${_FILE##*/}
                fi
                case $OPT_TYPE in
                    'create')
                        if [[ ! -e $LINK_NAME ]]; then
                            #echo ln -s $_FILE $LINK_NAME
                            ln -s $_FILE $LINK_NAME
                        else
                            echo "Link $LINK_NAME exists, Can not create it."
                        fi
                    ;;
                    'update')
                        #echo ln -f -s $_FILE $LINK_NAME
                        ln -f -s $_FILE $LINK_NAME
                    ;;
                    'delete')
                        #echo unlink $LINK_NAME
                        [[ -L $LINK_NAME ]] && unlink $LINK_NAME
                    ;;
                esac
            done
        ;;
    esac
done

[[ $NEED_LDCONFIG == 1 ]] && ldconfig
OK_OEF
chmod +x /hp/bin/hplink
#}}}

#{{{ 生成 /hp/etc/hp.ld.so.conf 文件
cat > /hp/etc/ld.so.conf.d/hp.ld.so.conf <<'OK_OEF'
include /etc/ld.so.conf.d/hp/*
OK_OEF

#}}}

#{{{ 创建软连接
[[ -L /etc/ld.so.conf.d/hp.ld.so.conf ]] || ln -s /hp/etc/hp.ld.so.conf /etc/ld.so.conf.d/hp.ld.so.conf
[[ -L /etc/ld.so.conf.d/hp ]] || ln -s /hp/etc/ld.so.conf.d /etc/ld.so.conf.d/hp
[[ -L /usr/include/hp ]] || ln -s /hp/include /usr/include/hp
#}}}

#{{{ 配置 bash 环境
# 添加 bash 的启动脚本 profile, 有交互界面的 bash 启动脚本
grep "source /hp/etc/hp.profile" /etc/profile > /dev/null 2>&1
if [[ $? -gt 0 ]]; then 
    echo "source /hp/etc/hp.profile" >> /etc/profile
fi
# 添加 bash 的启动脚本 bashrc,  无交互界面的 bash 启动脚本
grep "source /hp/etc/hp.bashrc" /etc/bash.bashrc > /dev/null 2>&1
if [[ $? -gt 0 ]]; then 
    echo "source /hp/etc/hp.bashrc" >> /etc/bash.bashrc
fi
#}}}

#{{{ 配置 sudo 环境
grep devel /etc/group>/dev/null 2>&1
if [[ $? -gt 0 ]]; then 
    group devel
    echo 'Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/hp/bin:/hp/sbin" ' >> /etc/sudoers
    echo "%devel ALL=(ALL) ALL " >> /etc/sudoers.d/sih
fi
#}}}
