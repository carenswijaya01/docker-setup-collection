node:20.13-alpine

custom setup for Oracle 11

add this line to your code to enable Thick mode, because Oracle 11 need to run in Thick mode

```js
const oracledb = require("oracledb");
oracledb.initOracleClient();
```

References:

- https://node-oracledb.readthedocs.io/en/latest/user_guide/installation.html
