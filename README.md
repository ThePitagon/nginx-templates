# Nginx Templates [<img src="https://img.shields.io/twitter/follow/ThePitagon.svg?label=Follow&style=social">](https://twitter.com/ThePitagon/)
Secure and fastify your nginx setup process with useful features using these templates.

General security features:
* Turn off `access log`, `error log` and `log not found` in default.
* Disable sensitive information.
* Disable sending the nginx version number in error pages and Server header.
* Disallow the browser to render the page inside a frame or iframe and avoid click-jacking in default.
* Disable content-type sniffing on some browsers.
* Enable the Cross-site scripting (XSS) filter built into most recent web browsers.
* Enable `Content Security Policy` (CSP) to tell the browser that it can only download content from the domains you explicitly allow.
* Enable Gzip.
* Caching for static files.
* Disable directory listing.
* Ignore common 404s.
* Disable direct access to Dotfiles.
* Prevent access to any files starting with a $ (usually temp files).
* Block executable file type.
* Allow ACME Challenge requests.
* Enable SSL common configurations.
* Built-in templates that help to create new website using virtual host easily:
    * `app` - App template: Redirect to an HTTP app using `proxy_pass`.
    * `static` - Static template: Serve static app like `HTML` app, `SPA` using `root`.
    * `wp` - WordPress template: Redirect to an HTTP website (that could be served by another web server, eg: Apache, OpenLiteSpeed, Docker Container, etc.).
    * `wp_php` - PHP WordPress template: Serve WordPress website using PHP FastCGI with `fastcgi_pass`.

WordPress' security features:
* Enable rate limit.
* Hide PHP version.
* PHP FastCGI default configuration.
* Common deny or internal locations, to help prevent access to areas of the site that should not be public.
* Block WordPress installation pages to avoid brute force attacks and for obscurity.
* Deny accesses to .php files in some directories (including sub-folders).
* Block common exploit requests.
* Block accesses to wp-config.php and any files similarly named.
* Limit XML-RPC Access.
* Limit Request Types.
* Block user enumeration to protect usernames.
* Reduce spam.

## Configuration
Edit the `env.sh` file to update the default Nginx directory.

## Installation
Clone this repository or copy the files from this repository into a new folder:
```
git clone https://github.com/ThePitagon/nginx-templates.git
```
Open a terminal, `cd` to the folder in which `nginx-templates` is saved.

## Data Structure
Cloned project
```bash
├── conf.d
├── html
├── includes
├── templates
├── apply.sh
├── env.sh
├── install.sh
├── LICENSE
├── make.env.sh
├── make.sh
├── nginx.conf
└── README.md
```

* `conf.d` contains default configurations for common uses.
* `html` contains nginx public files.
* `includes` contains configuration files for specific purposes.
* `templates` contains template files for ease of use.

## Usage
### Fresh install
Start fresh installation by run the following script:
```bash
./install.sh
```
### Apply to existed nginx
```bash
./apply.sh
```
### Creating new website from template
You can easily create a new website configuration by edit the `make.env.sh` file then execute the following command:
```
bash ./make.sh TEMPLATE_TYPE OUTPUT_PATH
```
* `TEMPLATE_TYPE` should be one of these values: [`app`, `static`, `wp`, `wp_php`]
* `OUTPUT_PATH` is path of the output file.

Then, check out the configuration file with the name `DOMAIN.conf` created in the `OUTPUT_PATH`. 

Examples:
```bash
./make.sh app apps
systemctl restart nginx
```

## Support & Feedback
If you still have a question after using Nginx Templates, you have a few options:
* Reporting any issue on [Github nginx-templates](https://github.com/ThePitagon/nginx-templates/issues/) project.
* Using support page on [Pitagon Website](https://pitagon.io/).
* [Send email to Pitagon Support Team](mailto:support@pitagon.vn) for help.
* Connect with author on [GitHub](https://github.com/travistran1989/).

**Pull requests are always welcome**

Tags: `wordpress`, `php`, `secure wordpress`, `nginx`, `secure nginx`
