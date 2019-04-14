---
id: api
title: Octoshield API
sidebar_label: Octoshield API
---

## API Token
Your API token is available from your account: https://app.octoshield.com/#/api

The token must be used as authorization header:

```bash
Authorization: Bearer <<Your Token>>
```
## Testing your token
Try to run the folowing query to get your list of tests:

```bash
curl -H 'Authorization: Bearer <<Your Token>>' https://app.octoshield.com/api/chaos-tests
[{"id":1,"name":"My Chaos Test","lastRunState":null,"lastRunDate":null,"lastRunDuration":null,"lastRunError":0,"env":"PREPROD","resourceDeleted":false}]
```

## API Documentation

Octoshield API details are available under [https://app.swaggerhub.com/apis-docs/octoshield/chaos-api](https://app.swaggerhub.com/apis-docs/octoshield/chaos-api)


*Note: Extra fields might be added to the api objects in a close future. Don't use strict mapping.* 

For more details, please [contact us ](../help.md).

