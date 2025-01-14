const {GlueClient, GetTableCommand, GetPartitionCommand, CreatePartitionCommand} = require("@aws-sdk/client-glue");
const glue = new GlueClient({});

exports.handler = async (event, context) => {
  let db = event.db
  let confs = event.athena
  let hive = event.hive
  let account_id = event.account_id
  let service = event.service
  let region = event.region
  let today = new Date()
  let errs = []

  for(let i = 0; i < confs.length; i++) {
    try {
      let cnf = confs[i]
      let tab = cnf['partitionTableName']
      let frq = cnf['frequency']

      let command = new GetTableCommand({
        DatabaseName: db,
        Name: tab,
      });
      let table = await glue.send(command);

      let strgDesc = table.Table['StorageDescriptor']
      let Values

      if(frq == "hourly"){
        if(hive == "true") {
          Values = ["aws-account-id=" + account_id, "aws-service=" + service, "aws-region=" + region, "year=" + String(today.getFullYear()), "month=" + ("0" + (today.getMonth() + 1)).slice(-2), "day=" + ("0" + today.getDate()).slice(-2), "hour=" + ("0" + today.getHours()).slice(-2)]
        } else {
          Values = [String(today.getFullYear()), ("0" + (today.getMonth() + 1)).slice(-2), ("0" + today.getDate()).slice(-2), ("0" + today.getHours()).slice(-2)]
        }
      } else {
          if(hive == "true") {
            Values = ["aws-account-id=" + account_id, "aws-service=" + service, "aws-region=" + region, "year=" + String(today.getFullYear()), "month=" + ("0" + (today.getMonth() + 1)).slice(-2), "day=" + ("0" + (today.getDate())).slice(-2)]
          } else {
            Values = [String(today.getFullYear()), ("0" + (today.getMonth() + 1)).slice(-2), ("0" + (today.getDate())).slice(-2)]
          }
      }
      try {
        let command = new GetPartitionCommand({
            DatabaseName: db,
            TableName: tab,
            PartitionValues: Values
        });
        await glue.send(command);
      } catch (err) {
          if(err.name === 'EntityNotFoundException'){
            console.log(strgDesc)
            let params = {
              DatabaseName: db,
              TableName: tab,
              PartitionInput: {
                StorageDescriptor: {
                    ...strgDesc,
                    Location: `${strgDesc.Location}${Values.join('/')}/`
                },
                Values,
              },
            }
            try{
              let command = new CreatePartitionCommand(params)
              await glue.send(command)
            } catch(err) {
              errs.push(err)
            }
          } else {
            errs.push(err)
        }
      }
    } catch (err) {
      errs.push(err)
    }
  }

  return new Promise((resolve, reject) => {
    if(errs.length > 0) {
      reject(errs);
    } else {
      resolve("SUCCESS")
    }
  });
}