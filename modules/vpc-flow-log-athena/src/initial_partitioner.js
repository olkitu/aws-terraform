const { GlueClient, GetTableCommand, GetPartitionCommand, CreatePartitionCommand } = require("@aws-sdk/client-glue");
const glue = new GlueClient({});

exports.handler =  async function (event, context) {
  let errs = [], status
  if (event.RequestType === 'Delete') {
    status = "SUCCESS"
  } else {
      console.log("Parsing athena configs")
      let rp = event
      let confs = rp.athenaIntegrations;
      let db = rp.dbName
      let hive = rp.hive
      let account_id = rp.account_id
      let service = rp.service
      let region = rp.region

      for(let i = 0; i < confs.length; i++) {
        let cnf = confs[i]
        let tab = cnf['partitionTableName']
        let frq = cnf['partitionLoadFrequency']
        let strt = (cnf['partitionStartDate'] == undefined) ? new Date() : new Date(cnf['partitionStartDate'])
        let end = (cnf['partitionEndDate'] == undefined) ? new Date() : new Date(cnf['partitionEndDate'])

        while(strt <= end) {
         try {
            let command = new GetTableCommand({
              DatabaseName: db,
              Name: tab,
            });
            let table = await glue.send(command);

            let strgDesc = table.Table['StorageDescriptor']
            let Values
            let newDate = new Date()

            if(frq == "monthly") {
              if(hive == "true") {
                Values = ["aws-account-id=" + account_id, "aws-service=" + service, "aws-region=" + region, "year=" + String(strt.getFullYear()), "month=" + ("0" + (strt.getMonth() + 1)).slice(-2)]
              } else {
                Values = [String(strt.getFullYear()), ("0" + (strt.getMonth() + 1)).slice(-2)]
              }
              newDate = strt.setMonth(strt.getMonth() + 1);
            } else if(frq == "hourly") {
              if(hive == "true") {
                Values = ["aws-account-id=" + account_id, "aws-service=" + service, "aws-region=" + region, "year=" + String(strt.getFullYear()), "month=" + ("0" + (strt.getMonth() + 1)).slice(-2), "day=" + ("0" + strt.getDate()).slice(-2), "hour=" + ("0" + strt.getHours()).slice(-2)]
              } else {
                Values = [String(strt.getFullYear()), ("0" + (strt.getMonth() + 1)).slice(-2), ("0" + strt.getDate()).slice(-2), ("0" + strt.getHours()).slice(-2)]
              }
              newDate.setHours(strt.getHours() + 1);
            } else {
              if(hive == "true") {
                Values = ["aws-account-id=" + account_id, "aws-service=" + service, "aws-region=" + region, "year=" + String(strt.getFullYear()), "month=" + ("0" + (strt.getMonth() + 1)).slice(-2), "day=" + ("0" + strt.getDate()).slice(-2)]
              } else {
                Values = [String(strt.getFullYear()), ("0" + (strt.getMonth() + 1)).slice(-2), ("0" + strt.getDate()).slice(-2)]
              }
              newDate = strt.setDate(strt.getDate() + 1);
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
            strt = new Date(newDate);
          } catch(err) {
            errs.push(err)
          }
        }
      }

    status = errs.length > 0 ? "FAILED" : "SUCCESS"
  }
}