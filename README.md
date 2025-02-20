<h1 style="text-align: center">
<img alt="logo" src="./assets/logo_wgb.jpg" width=350/>
<p align=center>A tool to manage WireGuard VPN connections.</p>
</h1>

## INSTALLATION

To install **WG-Bridge**, use:

```sh
./wg-bridge-installation install
```

## UNINSTALLATION

To remove **WG-Bridge**, use:

```sh
./wg-bridge-installation uninstall
```

## UPDATE

To remove **WG-Bridge**, use:

```sh
./wg-bridge-installation install --update
```

or

```sh
./wg-bridge-installation install -u
```

## SYNOPSIS

**wgb** [**OPTIONS**] [**COMMANDS**] [**ARGUMENT**]

## DESCRIPTION

**wgb** is a command-line tool designed to handle WireGuard VPN
connections. It allows users to connect, disconnect, list available
configurations, and check the status of connections.

## OPTIONS

### -v | --verbose

Enable a verbose logging

### -h | --help

Print in standard output an help message

## COMMANDS

### connect [<config_path>]

Establish a VPN connection using the specified WireGuard configuration file.

- **config_path**: (optional) full path to the WireGuard configuration file.

**Example:**

```sh
wgb connect
```

```sh
wgb connect /path/to/config.conf
```

### disconnect [<config_path>]

Terminate the VPN connection associated with the specified WireGuard
configuration file.

- **config_path**: (optional) full path to the WireGuard configuration file.

**Example:**

```sh
wgb disconnect /path/to/config.conf
```

```sh
wgb disconnect
```

### list

List all available WireGuard configurations.

**Example:**

```sh
wgb list
```

### status

Display the current status of active WireGuard connections.

**Example:**

```sh
wgb status
```

## CONFIGURATION FILE

The software uses a configuration file located in the user's home directory:

**~/.wgbconf.json**

### Configuration Properties

- **conf_path** *(array)*: List of full paths to directories containing
WireGuard configuration files.
- **error_codes** *(object)*: Mapping of error codes to error messages.
  - Example:

    ```json
    "error_codes": {
        "000": "Missing wgb configuration"
    }
    ```

- **confs** *(array)*: Contains the properties of each configuration

**Example Configuration File:**

```json
{
    "conf_path": ["/etc/wireguard/", "/home/user/"],
    "error_codes": {
        "000": "Missing wgb configuration"
    },
    "token": false,
    "token_uri": ""
}
```
