# Shell profile customizations in /etc/profile.d

class profile {

    augeas { 'no beeps':
        incl    => '/etc/inputrc',
        lens    => 'inputrc.lns',
        changes => [ 'set bell-style none' ]
    }

    $profile = @(PROFILE/L)
        alias vi=vim
        alias hc='rm -f ~/.bash_history; history -c'
        HISTSIZE=1000
        HISTFILESIZE=0
        | PROFILE

    file { '/etc/profile.d/custom.sh' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $profile,
    }

    $pupaliases = @(PUPALIASES/L)
        alias pat='if [ $UID -eq 0 ]; then puppet agent --test; fi'
        alias pcl='if [ $UID -eq 0 ]; then cat $(puppet agent --configprint classfile); fi'
        alias prl='if [ $UID -eq 0 ]; then cat $(puppet agent --configprint resourcefile); fi'
        alias pae='sudo -i puppet agent --configprint environment'
        | PUPALIASES

    file { '/etc/profile.d/custom-puppet.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $pupaliases,
    }

    $coloredless = @(COLOREDLESS/L)
        export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
        export LESS='-R '
        | COLOREDLESS

    file { '/etc/profile.d/custom-colors.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $coloredless,
    }

}

