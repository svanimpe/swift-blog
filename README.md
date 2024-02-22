# A Swift Blog

This repository hosts the source code that I used for a personal website and blog. Instead of using a CMS, I decided to write my own solution in Swift and make it available to the community. As this is my first server-side Swift release, I did not go all out on features but tried to keep the code small, approachable and easy to understand.

## How it works

The app uses [Kitura](http://www.kitura.io) as a web server. Even if you're unfamiliar with Kitura, you should be able to understand the code as it only does basic routing and template rendering.

Templates are created using the [Stencil](https://stencil.fuller.li/) template language. Even though most pages contain only static content, using a template language severely reduces the amount of HTML required. The following parent templates are used to build pages:

- `template-base` contains the basic structure of the site. It is only used as a starting point for other parent templates, never directly.
- `template-main` extends `template-base` and is the parent template for the site's main pages (`index`, `books`, `blog` and `about`).
- `template-blog` extends `template-base` and is the parent template for blog posts. 

To keep the app as simple as possible, I did not use a database. Instead, the list of blog posts is stored in `posts.json`. This file is loaded when the app starts. Its contents are used to build the `blog` page. Every entry in `posts.json` should also have a corresponding page in `blog/`.

## Deploying locally

The only requirement to build and run this app is Swift 4.2. On macOS, install Xcode 10 through the Mac App Store and launch it at least once to complete the installation process. On Linux, get it from [swift.org](https://swift.org/getting-started/). After installing Swift 4, verify it's working properly by executing `swift --version` on the command line.

You can now download, build and run the app as follows:

```
git clone https://github.com/svanimpe/swift-blog.git
cd swift-blog
swift run
```

Once Kitura starts, the app will be available at [http://localhost:8080/](http://localhost:8080/).

## Developing on macOS

You can use the following commands to create and open an Xcode project:

```
swift package generate-xcodeproj
open swift-blog.xcodeproj
```

You'll need to regenerate the Xcode project any time you change the project's dependencies in `Package.swift`.

## Developing on Linux

On Linux, I recommend [Visual Studio Code](https://code.visualstudio.com) as an editor. It has basic support for Swift built-in. To run the app in Visual Studio Code, you can use the integrated terminal and execute `swift run` there.

On both macOS and Linux, I recommend you install my <a href="https://marketplace.visualstudio.com/items?itemName=svanimpe.stencil">Stencil extension for Visual Studio Code</a>. As described in the extension's documentation, press **F1**, select **Open Settings (JSON)** and add the following to your settings if you're using Stencil only for HTML:

```
"files.associations": {
    "*.stencil": "stencil-html"
},
```

## Deploying to IBM Cloud

Hosting Swift apps on IBM Cloud is extremely easy, thanks to the [Swift buildpack](https://github.com/IBM-Swift/swift-buildpack). Because this app uses very little memory and does not require a database, hosting it is free. An IBM Cloud account includes 256MB of memory for free per month. You can increase this to 512MB by adding a credit card and upgrading to a pay-as-you-go account.

If you don't yet have an IBM Cloud account, sign up for free at [https://console.bluemix.net/](https://console.bluemix.net/). When configuring your account, choose the region where you'd like to host your app and create an organization and space.

Next, download the [IBM Cloud Developer Tools](https://console.bluemix.net/docs/cli/index.html). Once you have them installed, run the following commands to configure them:

```
ibmcloud login
ibmcloud target -o <organization> -s <space>
```

The first command will ask you for your IBM Cloud credentials. For the second command, replace `<organization>` and `<space>` with the appropriate values.

Deployment settings are stored in `manifest.yml`:

```
applications:
- name: svanimpe
  memory: 128M
  buildpack: swift_buildpack
  command: swift-blog
```

These settings tell IBM Cloud to use the Swift buildpack, how much memory to allocate, which command to run and what to call your app. Simply replace `svanimpe` with the name of your app and you're good to go.

Finally, run:

```
ibmcloud app push
```

This will deploy your app using the settings in `manifest.yml`. The output of this command contains the URL where your app is available.

To monitor your app or change its settings, use either the command-line tools or the [web console](https://console.bluemix.net/).

### Setting up a custom domain

If you've purchased a domain name and would like to use this domain for your app, follow these steps.

First, go to the website of your registrar (the company where you've purchased the domain name) and find the page where you can configure the DNS records for your domain. Here, you need to add an **A-record** to point the domain at IBM's servers. The IP address you need to use depends on the region where your app is hosted:

- **US-SOUTH**: 158.85.156.20 (secure.us-south.bluemix.net)
- **EU-GB**: 5.10.124.142 (secure.eu-gb.bluemix.net)
- **AU-SYD**: 168.1.35.166 (secure.au-syd.bluemix.net)
- **EU-DE**: 158.177.81.250 (secure.eu-de.bluemix.net)

If you want to configure additional subdomains, you can use either A-records or CNAME-records, but at least one A-record is required.

Next, add the domain to your IBM Cloud account. On the [web console](https://console.bluemix.net/), go to **Manage** > **Account** > **Cloud Foundry Orgs** > **...** > **Domains**. Here you can add your domain. If you've purchased an SSL certificate, you can upload it here as well.

Finally, configure the routes for your app. On the dashboard for your app, go to **Routes** > **Edit routes** and add the routes you'd like to use.

For example, I used the following A-records:

- [svanimpe.be](http://svanimpe.be) -> 5.10.124.142
- [www.svanimpe.be](http://svanimpe.be) -> 5.10.124.142

After adding this domain to my account, I set up the following routes for my app:

- [svanimpe.eu-gb.mybluemix.net](http://svanimpe.be)
- [svanimpe.be](http://svanimpe.be)
- [www.svanimpe.be](http://svanimpe.be)

Note that changes to DNS records require some time to take effect, so wait at least a day before assuming you've made a mistake.
