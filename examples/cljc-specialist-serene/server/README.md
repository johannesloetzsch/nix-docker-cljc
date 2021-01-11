# example-specialist

This is the example Graphql-Server from [specialist-server](https://github.com/ajk/specialist-server). It was rewritten using `defn-spec` from [orchestra](https://github.com/jeaye/orchestra).

## Running

To start the server and send queries, run:

```bash
lein ring server

curl -H 'Content-type: application/json' -d '{"query":"{ hello { greeting }}"}' http://localhost:3000/graphql
curl -H 'Content-type: application/json' -d '{"query":"{ hello(name:\"Clojure!\") { greeting happy }}"}' http://localhost:3000/graphql
```

## Testing

The example includes tests with `orchestra.spec.test/instrument`

```bash
lein test
```
