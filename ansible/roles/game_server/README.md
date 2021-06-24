# game_server: Install and configure a game's dedicated server instance

This role installs and configures a game's dedicated server instance.\
The role's prefix in the source code is **gs**.

Currently supported games are:
- Terraria
  - Launches as a systemd service through tmux on boot, on session `terraria`.
- Minecraft (TODO)
- Starbound (TODO)

## Requirements

- git
- g++ and gcc compilers
- make
- tmux
- unzip
- ufw (Uncomplicated Firewall)
- iptables

All of these dependencies are installed by the role Global.\
This role also installs ZeroTier One and joins a network defined in a secret file, placed in this repo's global shared folder, specifically `/shared/private/secrets.yml`.

## Dependencies

There are no dependencies, but running the role Global is advisable prior to running this role, since it makes sure all the necessary dependencies are present.

## Role variables

Global role variables:
- **gs_overwrite**: (bool) Decides whether or not an existing instance of the game's server will be overwritten if found, default `false` - which *fails the play in case an instance is detected;*
- **gs_type**: (enum, string) Decides the type of server to be installed. Currently supported values are (or will be):
  - `terraria`
  - `minecraft`
  - `starbound`
- **game_server**: (dict) Secret variable placed on this repo's `/shared/private/secrets.yml` file (global shared folder). Has 1 key-value pair only:
  - zt_network: (string) The network ID to join.
- **gs_install_zerotier**: (bool) Decides whether or not ZeroTier One will be installed. If this is false, the variable *gs_server_ip* **has** to be provided!
- **gs_server_ip**: (string) The server's IP to listen to. Automatically defined if ZeroTier is to be installed, else it must be defined manually.
  - If its value is set to `update` then it will skip the fail check for a valid server IP.
  - The `update` value is intended to update installs in an automated way.

Terraria role variables:
- **gs_terraria_**: Prefix for the following variables:
  - `link`: (string) Link to the zipped dedicated server instance to install, defaults to terraria.org's v1.4.2.
  - `install_dir`: (string) Absolute path to the server instance's installation folder. The worlds folder will be created on the exact same folder, save for a "_worlds" appended to the name.
    - Example: By default the path is `/home/vagrant/terraria`, so the worlds folder will be `/home/vagrant/terraria_worlds`.
  - `port`: (string | int) Port number to use, defaults to Terraria's default, 7777.
  - `world_name`: (string) The world name to use - the world will be saved in the .wld extension with that name too. Defaults to "Aurellia", because I like that name.
  - `autocreate_size`: (int) The world size to be autocreated with. Valid values:
    - `1`: Small world.
    - `2`: Medium world (default).
    - `3`: Large world.
  - `seed`: (string) The world seed. Defaults to the drunk world seed (05162020).
  - `difficulty`: (int) The difficulty. Valid values:
    - `0`: Normal.
    - `1`: Expert.
    - `2`: Master.
    - `3`: Journey (default).
  - `password`: (string) The server password. Defaults to 420, because memes.
  - `max_players`: (int) The maximum number of players allowed at a time. Defaults to Terraria's default, 8.
  - `motd`: (string) The server's message of the day. Defaults to a parody of Minecraft's default MOTD.
- As was mentioned at the top, the prefix for all of these is `gs_terraria_`, so for instance, to refer to the `link` variable, use `gs_terraria_link`.

More role variables to come as the tasks for Minecraft and Starbound are developed.

## Example Playbook

    - hosts: servers
      roles:
        - role: global
          become: yes
        
        - role: game_server
          become: yes
          vars:
            gs_overwrite: yes
            gs_type: terraria
            gs_terraria_motd: "My Terraria dedicated server"
            gs_terraria:
              link: "https://terraria.org/dedicatedserver/restoflink/terraria-server-1412.zip"
              install_dir: /home/myuser/terraria-server
              port: 1234
              world_name: 'My HARDCORE world'
              autocreate_size: 1
              seed: for the worthy
              difficulty: 2
              password: thor
              max_players: 5
            
All of the vars can be omitted, in which case they will assume their defaults - with the notable exception of `gs_type`, which has no default.

## License

MIT License

## Author

It's a me, [Leonardo "Yuriel" Valim](mailto:emberbec@gmail.com)
