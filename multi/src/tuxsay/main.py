import cowsay

def lambda_handler(event, context):
    cowsay.tux(event["message"])

if __name__ == "__main__":
    test_event = {
        "message": "hello world"
    }
    # test
    lambda_handler(test_event, None)
