# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://transformap.co"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
			]

			# The default title of our website
			title: "TransforMap"

			# The website description (for SEO)
			description: """
				TransforMap works towards an online platform for you to visualize the myriads of alternatives to the dominant economic thinking on a single mapping system.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				openstreetmap, OSM, open street map, open source, mapping, leaflet, linked data, mapping taxonomy, open data, solidarity economy, alternative economy
				"""

			# The website author's name
			author: "TransforMap Community"

			# The website author's email
			email: "kei@ourmachine.net"

			# Styles
			styles: [
				"//fonts.googleapis.com/css?family=PT+Sans:400,400italic,700,700italic&subset=latin,latin-ext"
				"//fonts.googleapis.com/css?family=Open+Sans:400,400italic,700,700italic&subset=latin,latin-ext"
				"//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
				"/styles/twitter-bootstrap.css"
				"//cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css"
				"/styles/style.css"
			]

			# Scripts
			scripts: [
				"//cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"
				"/vendor/twitter-bootstrap/dist/js/bootstrap.min.js"
				"//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.5.2/underscore-min.js"
				"//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.0/backbone-min.js"
				"//cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js"
				"/vendor/PruneCluster/PruneCluster.js"
				"/scripts/script.js"
			]

			# Piwik
			# via https://github.com/webplatform/www.webplatform.org/blob/3590651a736ad8e8b8ff2cb73c35ba87f2973f7b/src/layouts/base.html.eco
			piwik_id: 7

		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({tags:$has:'post'}, [date:-1])


	# =================================
	# Plugins

	plugins:
		ghpages:
			deployRemote: 'origin'
			deployBranch: 'master'
		downloader:
			downloads: [
				{
					name: 'Bootstrap'
					path: 'src/static/vendor/twitter-bootstrap'
					url: 'https://codeload.github.com/twbs/bootstrap/tar.gz/master'
					tarExtractClean: true
				}
			]
		cleanurls:
			static: true
			trailingSlashes: true


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
	# setting local hostname
	# via http://stackoverflow.com/a/21278511/1959568
	environments:
		development:
			hostname: 'localhost'
}


# Export our DocPad Configuration
module.exports = docpadConfig
