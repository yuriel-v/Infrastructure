# dev_base_ubuntu: Development environment base install, Ubuntu version

This role provisions a development master machine, that is, a machine used to develop just about any kind of application you work with.
By default, this role installs the following:

- Visual Studio Code
- Insomnia
- GitKraken
- AdoptOpenJDK 11 Hotspot
- Maven

## Requirements

The only requirement is that the target OS must be Ubuntu.

## Dependencies

The only dependency is the role Global, also included in this repository.

## Role variables

No modifiable variables have been defined.

## Example Playbook

    - hosts: servers
      roles:
        - role: global
          become: yes

        - role: dev_base_ubuntu
          become: yes

## License

MIT License

## Author

It's a me, [Leonardo "Yuriel" Valim](mailto:emberbec@gmail.com)
