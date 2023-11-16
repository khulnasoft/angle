package metadata

// These sources produce JSON providing a structured representation of the
// Angle GraphQL API

api: {
	description:     !=""
	schema_json_url: !=""
	configuration:   #Schema
	endpoints:       #Endpoints
}

api: {
	description:     """
		The Angle [GraphQL](\(urls.graphql)) API allows you to interact with a
		running Angle instance, enabling introspection and management of
		Angle in real-time.
		"""
	schema_json_url: "https://github.com/khulnasoft/angle/blob/master/lib/angle-api-client/graphql/schema.json"
	configuration: {
		enabled: {
			common: true
			type: bool: default: false
			required:    false
			description: "Whether the GraphQL API is enabled for this Angle instance."
		}
		address: {
			common:   true
			required: false
			type: string: {
				default: "127.0.0.1:8686"
				examples: ["0.0.0.0:8686", "localhost:1234"]
			}
			description: """
				The network address to which the API should bind. If you're running
				Angle in a Docker container, make sure to bind to `0.0.0.0`. Otherwise
				the API will not be exposed outside the container.
				"""
		}
		playground: {
			common:   false
			required: false
			type: bool: default: true
			description: """
				Whether the [GraphQL Playground](\(urls.graphql_playground)) is enabled
				for the API. The Playground is accessible via the `/playground` endpoint
				of the address set using the `bind` parameter.
				"""
		}
	}

	endpoints: {
		"/graphql": {
			POST: {
				description: """
					Main endpoint for receiving and processing
					GraphQL queries.
					"""
				responses: {
					"200": {
						description: """
							The query has been processed. GraphQL returns 200
							regardless if the query was successful or not. This
							is due to the fact that queries can partially fail.
							Please check for the `errors` key to determine if
							there were any errors in your query.
							"""
					}
				}
			}
		}
		"/health": {
			GET: {
				description: """
					Healthcheck endpoint. Useful to verify that
					Angle is up and running.
					"""
				responses: {
					"200": {
						description: "Angle is initialized and running."
					}
				}
			}
		}
		"/playground": {
			GET: {
				description: """
					A bundled GraphQL playground that enables you
					to explore the available queries and manually
					run queries.
					"""
				responses: {
					"200": {
						description: "Angle is initialized and running."
					}
				}
			}
		}
	}
}
