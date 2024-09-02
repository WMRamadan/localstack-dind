const handler = (payload, context, callback) => {
    console.log(`Function apiHandler called with payload ${JSON.stringify(payload)}`);
    callback(null, {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Cheers from AWS Lambda!!'
        })
    });
}

module.exports = {
    handler,
}
