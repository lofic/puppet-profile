# Shell profile customizations in /etc/profile.d

class profile {

    $profileentries = [
        'alias vi=vim',
        "alias hc='rm -f ~/.bash_history; history -c'",
        'HISTSIZE=1000',
        'HISTFILESIZE=0',
    ]

    file { '/etc/profile.d/custom.sh' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => inline_template(
            "<% @profileentries.each do |pe| -%><%= pe %>\n<% end -%>"
        )
    }

    $pupaliases = [
        'alias pat=\'if [ $UID -eq 0 ]; then puppet agent --test; fi\'',
        'alias pcl=\'if [ $UID -eq 0 ]; then cat $(puppet agent --configprint classfile); fi\'',
        'alias prl=\'if [ $UID -eq 0 ]; then cat $(puppet agent --configprint resourcefile); fi\'',
        "alias pae='sudo -i puppet agent --configprint environment'",
    ]

    file { '/etc/profile.d/custom-puppet.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => inline_template(
            "<% @pupaliases.each do |pa| -%><%= pa %>\n<% end -%>"
        )
    }

    augeas { 'no beeps':
        incl    => '/etc/inputrc',
        lens    => 'inputrc.lns',
        changes => [ 'set bell-style none' ]
    }

}

