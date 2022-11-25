# Nginx Templates
[<img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white">](https://www.linkedin.com/company/pitagon/)
[<img src="https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white">](https://www.facebook.com/ThePitagon/)
[<img src="https://img.shields.io/twitter/follow/ThePitagon.svg?label=Follow&style=social">](https://twitter.com/ThePitagon/)

Secure and fastify your nginx setup process with useful features using these templates.

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
If you still have a question after using MySQL Docker Environment, you have a few options.
* Using support page on [Pitagon Website](https://pitagon.io).
* Send email to [Pitagon Support Team](mailto:support@pitagon.vn) for help.
* Connect [Travis Tran on Facebook](https://www.facebook.com/travistran1989) for real-time discussion.
* Reporting any issue on [Github nginx-templates](https://github.com/ThePitagon/nginx-templates/issues) project.

**Pull requests are always welcome**

Tags: `wordpress`, `php`, `secure wordpress`, `nginx`, `secure nginx`
