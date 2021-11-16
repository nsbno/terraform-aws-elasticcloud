
const AWS = require('aws-sdk');
const kms = new AWS.KMS();

exports.handler = async (event, context, callback) => {
    let pass = process.env.encpass;
    let usr = process.env.username;
    let secret = null;

  let params = {
    CiphertextBlob: Buffer.from(process.env.encpass, 'base64')
  }

  try {
    const decrypted = await kms.decrypt(params).promise();
    secret = decrypted.Plaintext.toString('utf-8');
  }
  catch (exception) {
    console.log('Error!!!')
    console.error(exception);
  }
  
    const response = {
        statusCode: 200,
        body: JSON.stringify(usr + '  - ' + secret + '  - '),
    };
    return response;
};
