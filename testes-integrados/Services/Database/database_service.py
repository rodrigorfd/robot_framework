from pymongo import MongoClient
from bson.objectid import ObjectId
import requests

def _get_dev_database():
    mongo_db_url = ''
    return MongoClient(mongo_db_url).bbc_dev

def _get_hml_database():
    mongo_db_url = ''
    return MongoClient(mongo_db_url).heroku_wr086srw

def remover_registerUpdate_by_cpf(document):
    users_collection = _get_hml_database().users
    users_collection.update_one({'cpf': document}, {'$unset': {'registerUpdate': ''}})

def atualizar_encrypted_password(cpf, novo_password):
    users_collection = _get_hml_database().users
    result = users_collection.update_one(
        {'cpf': cpf},
        {'$set': {'encrypted_password': novo_password}}
    )
    return result.modified_count