#!/usr/bin/env python3

from argparse import ArgumentParser, Namespace
from time import sleep

from config import Config
from iva_client import IvaClient


def parse_args() -> Namespace:
    parser = ArgumentParser()

    parser.add_argument("--config", type=str, required=True)
    parser.add_argument("--profile", type=str, required=True)

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    config = Config.from_path(args.config)

    sleep(config.jitter.randomize_jitter())

    iva = IvaClient(config.iva_host, config.credentials)

    iva.send_message(config.chat_id, config.profiles[args.profile].pick_message())