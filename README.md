# WG-Bridge

A tool to manage WireGuard VPN connections.

## SYNOPSIS

**wireguard-bridge** [**OPTIONS**]

## DESCRIPTION

**wireguard-bridge** is a command-line tool designed to handle WireGuard VPN
connections. It allows users to connect, disconnect, list available
configurations, and check the status of connections.

## OPTIONS

## --connect [<config_path>]

Establish a VPN connection using the specified WireGuard configuration file.

- **config_path**: (optional) Path to the WireGuard configuration file.

**Example:**

```sh
wgb --connect
```

```sh
wgb -c /path/to/config.conf
```

## --disconnect [<config_path>]

Terminate the VPN connection associated with the specified WireGuard
configuration file.

- **config_path**: (optional) Path to the WireGuard configuration file.

**Example:**

```sh
wgb --disconnect /path/to/config.conf
```

```sh
wgb -d
```

## --list

List all available WireGuard configurations.

**Example:**

```sh
wgb list
```

## status

Display the current status of active WireGuard connections.

**Example:**

```sh
wgb status
```

## CONFIGURATION FILE

The software uses a configuration file located in the user's home directory:

**~/.wgb.json**

### Configuration Properties

- **conf_path** *(array)*: List of paths to WireGuard configuration files.
- **error_codes** *(object)*: Mapping of error codes to error messages.
  - Example:

    ```json
    "error_codes": {
        "000": "Missing wgb configuration"
    }
    ```

- **token** *(boolean)*: Indicates whether a two-factor authentication system
is enabled.
- **token_uri** *(string)*: The URI used for token input if 2FA is enabled.

**Example Configuration File:**

```json
{
    "conf_path": ["/etc/wireguard/wg0.conf", "/etc/wireguard/wg1.conf"],
    "error_codes": {
        "000": "Missing wgb configuration"
    },
    "token": false,
    "token_uri": ""
}
```

## INSTALLATION

To install **wireguard-manager**, use:

```sh
wireguard-manager install
```

## UNINSTALLATION

To remove **wireguard-manager**, use:

```sh
wireguard-manager uninstall
```

## EXIT STATUS

**wireguard-manager** returns the following exit codes:

- **0**: Success
- **1**: General error
- **000**: Missing WireGuard configuration

## EXAMPLES

Connect using a specific configuration file:

```sh
wireguard-manager connect /etc/wireguard/wg0.conf
```

Disconnect a specific configuration:

```sh
wireguard-manager disconnect /etc/wireguard/wg0.conf
```

Check the status of active connections:

```sh
wireguard-manager status
```
