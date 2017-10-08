from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from bson.objectid import ObjectId
import bcrypt
import json
from CustomClass import JSONEncoder
from flask import jsonify

app = Flask(__name__)
client = MongoClient('mongodb://localhost:27017/')
app.db = client.trip_planner_development
app.bcrypt_rounds = 12
api = Api(app)


class User(Resource):
    def post(self):
        requested_json = request.json
        # We have a holder for the json requested data

        collection_of_posts = app.db.posts

        '''Now that we have the document we have to check the neccesary document and see if it has the neccesary crede
        ntials '''

        if 'username' in requested_json and 'email' in requested_json and 'password' in requested_json:
            collection_of_posts.insert_one(requested_json)
            print("This document has all the neccesary credentials needed to be implemented")
            return(collection_of_posts, 200, None)
        else:
            print('This document could not be inserted into our database')
            return(None, 404, None)

    def get(self):
            # The function that ill be fetching our resources from the database
            # So we need access to the database and collection_
            collection_of_posts = app.db.posts

            # Now that we have the collection lets fetch some resources
            #  We have to get the arguments of the users credentialls

            user_email = request.args.get('email')
        # And the reason that we have to use get because it is getting the raw value  for the string


            # since then emails are unique we will use them as our fetching tool
            user_find = collection_of_posts.find_one({"email": user_email})

            # Now we have to do some error handling
            if user_find is None:
                print('Sorry the user can not be found')
                return(None, 204,None)
            elif user_find is not None:
                return(user_email, 200, None)


    # def put(self):
    #     #  This method is what edits resources
    #
    #     # First we need access to these resources


api.add_resource(User, '/users')

@api.representation('application/json')
def output_json(data, code, headers=None):
    resp = make_response(JSONEncoder().encode(data), code)
    resp.headers.extend(headers or {})
    return resp
# Encodes our resouces for us


if __name__ == '__main__':
    # Turn this on in debug mode to get detailled information about request related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)
