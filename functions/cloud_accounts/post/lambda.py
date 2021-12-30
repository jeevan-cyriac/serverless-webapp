#!/usr/bin/env python3

"""
GET handler for Retrieve Cloud account(s)
"""

import os
from finops.api_utils import (
    helper,
    http_status
)


def lambda_handler(event=None, context=None):
    """
    GET lambda_handler for cloud accounts.
    """
    data = event.get('body')

    # TODO: add data to database

    return helper.generate_response(status_code=http_status.HTTP_200_OK)

if __name__ == '__main__':
    lambda_handler()
