#!/bin/bash

# Run mongosh to initiate the replica set
mongosh --eval 'rs.initiate({ _id: "myReplicaSet", members: [{ _id: 0, host: "192.168.61.26:27017" }] })'
