# HTTIES
**HT**TP **T**ools for **I**nspection, **E**nhancement, and **S**peed

A small library for easy network requests.

**Small project that uses this library**: [MVArchitectureDemo](https://github.com/illescasDaniel/MVArchitectureDemo)

## Features:
- **Asynchronous Networking**: Utilize modern Swift concurrency features for async network calls.
- **Request and Response Interceptors**: Customize requests and responses with multiple interceptors.
- **Generic Decoding**: Automatically decode JSON responses into Swift types.
- **HTTP Method Enum**: Easily specify HTTP methods with a convenient enum.
- **URL Operator Overloading**: Simplify URL construction with custom operators.
- **Extensive Error Handling**: Handle common and custom networking errors with built-in error types.
- **Flexible Request Initialization**: Support for URL, query parameters, body data, and headers in requests.

Notes:
- The code coverage is as close to 100% as possible (90%+)
- The unit tests were mostly created by ChatGPT :)

## Basic Usage Example

In this example, we will perform a GET request to fetch a list of users and decode the JSON response into a Swift object. We also demonstrate the use of an HTTP interceptor to log the request and response details.

### Define your model

First, define a model to represent the JSON response:

```swift
struct User: Decodable {
    let id: Int
    let name: String
    let username: String
}
```

### Create an HTTP Client
Set up an HTTP client and add a request logger interceptor:

```swift
// import the library
import HTTIES

// Set up the HTTP client with a logging interceptor (code for the interceptor below)
let session = URLSession.shared
let client = HTTPClientImpl(httpDataRequestHandler: session, interceptors: [RequestLoggerHTTPInterceptor()])
```

### Build the URL
Utilize custom operators to build the URL for the request:

```swift
// Use the custom "/" operator to build the URL
let baseURL = URL(string: "https://example.com/api")!
let endpointURL = baseURL / "api" / "v1" / "users" /? ["sortBy": "name", "ascending": nil]
// endpointURL is "https://example.com/api/api/v1/users?ascending&sortBy=name"
```

### Perform the GET request
```swift
// Perform a GET request and decode the JSON response into an array of `User`
let usersRequest = try HTTPURLRequest(url: endpointURL)
let users: [User] = try await client.data(for: usersRequest, decoding: [User].self)

// Handle the fetched users
print("Fetched users: \(users)")
```

## Response interceptor Example
A simple response interceptor that logs the request and response details is included as follows:

```swift
import HTTIES

final class RequestLoggerHTTPInterceptor: HTTPResponseInterceptor {
    func intercept(data: Data, response: HTTPURLResponse, error: Error?, for request: URLRequest) -> (Data, HTTPURLResponse, Error?) {
        // Consider using a logger class :)
        print("""
        ----
        - Request: \(request.url?.path(percentEncoded: false) ?? "nil")
          - Body parameters: \(request.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "nil")
        - Response: \(response.statusCode)
          - Body content: \(String(decoding: data, as: UTF8.self))
        ----
        """)
        return (data, response, error)
    }
}
```

## Request interceptor Example
A simple request interceptor that modifies the Authorization http header to include an authentication token:

```swift
import HTTIES

final class AuthTokenInterceptor: HTTPInoutRequestInterceptor {
    var token: String

    init(token: String) {
        self.token = token
    }

    func intercept(request: inout URLRequest) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
```
