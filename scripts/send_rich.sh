#!/bin/bash

udid=$(xcrun simctl list devices | grep -E 'Booted' -A 1 | grep -o -E '[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}' | head -n 1)

xcrun simctl push $udid com.demo.PushDemo push_payloads/payload_rich.apns
