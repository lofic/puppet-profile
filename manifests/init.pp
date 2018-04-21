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
        "alias pat='puppet agent --test'",
        "alias pcl='cat $(puppet agent --configprint classfile)'",
        "alias prl='cat $(puppet agent --configprint resourcefile)'",
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

