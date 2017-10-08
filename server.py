from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from bson.objectid import ObjectId
import bcrypt
import json
from CustomClass import JSONEncoder
from flask import jsonify
import pdb


app = Flask(__name__)
client = MongoClient('mongodb://localhost:27017/')
database = app.db = client.trip_planner_development
app.bcrypt_rounds = 12
api = Api(app)


class User(Resource):
    def post(self):
        requested_json = request.json
        # We have a holder for the json requested data

        collection_of_posts = database.posts

        '''Now that we have the document we have to check the neccesary document and see if it has the neccesary crede
        ntials '''

        if 'username' in requested_json and 'email' in requested_json and 'password' in requested_json:
            collection_of_posts.insert_one(requested_json)
            print('The document has been implemented')
            # pdb.set_trace()
            return(requested_json, 201, None)
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

    def put(self):
        # This function is what essentially edits the resources
        # This function is what essentially edits the resources

        '''So what we are essentially going to need for the function is
        the ability to edit resources therefore we need access to the collection'''
        collection_of_posts = database.posts
        # Now that we have the collection we can no edit the resources

        # This fetching the documents from mongo
        user_email = request.args.get('email')

        # This is getting the raw value for the username from the post request
        user_username = request.json.get('username')

        # Now that we have the two we can common and then from there we can edit the information
        # We now have to locate the document with the specific problems
        user_query = collection_of_posts.find_one({'email': user_email})
        # So now we essentially have access to all the documents with emails in them
        if user_query is None:
            '''Some simple user querying to see if the documents we actually
            are checking contain any information essentially some simple error
            handling'''
            print('Invalid documents sorry!')
            return(None, 404, None)
        elif user_query is not None:
            user_query['username'] = user_username
            collection_of_posts.save(user_query)
            print('The documents have been edited')
            return(user_query, 200, None)

    def delete(self):
        # This is essentially the function to delete users and their accounts
        '''We are going to take the collection find the specific email and remove it
        using the remove method'''

        # Therefore first we have to find the document
        collection_of_posts = database.posts

        # Now let us fetch the email from the database as a unique identifier
        user_email = request.args.get('email')

        # Now that we have the email we can delete it using a general query
        user_query = collection_of_posts.find_one({'email': user_email})

        # Now we can delete the resources
        if user_query is None:
            print('The user could not be found to be deleted')
            return(None, 404, None)
        else:
            collection_of_posts.remove(user_query)
            print('The user has successfully been deleted')
            return(user_query, 204, None)

    def patch(self):
        # So essentially this edits the whole doc as oppose to a singularity

        # So first we need to find the document through a unique identifier
        collection_of_posts = database.posts

        # Now that we have the collection we can now patch the resources
        # By finding the docs with their unique identifier
        user_email = request.args.get('email')

        user_username = request.json.get('email')
        user_username = request.json.get('username')
        user_password = request.json.get('password')
        # So now that we have all the neccesary resources we can now patch the docs
        user_query = collection_of_posts.find_one({'email': user_email})

        # Now we implement the error handling
        if user_query is None:
            print('Sorry the document could not be found, therefore could not be patched')
            return(None, 404, None)
        else:
            user_query['email'] = user_email
            user_query['username'] = user_username
            user_query['password'] = user_password
            print('The existing document has succesfully been patched')
            return(user_query, 200, None)


class Trips(Resource):
    # This is essentially the same as the users class but for the Trips
    def post(self):
        # This is essentially going to be able to post resource to our trip collection

        # Now we have to get access to the new collection that we are making
        collection_of_trips = database.trips

        # Now that we have access to the collection we can begin to post the resources
        requested_json = request.json

        if 'email' in requested_json:
            collection_of_trips.insert_one(requested_json)
            print('The document does have an email address in it')
            return(requested_json, 201, None)
        else:
            print("The document did not contain the email")
            return(None, 404, None)



api.add_resource(User, '/users')
api.add_resource(Trips, '/trips')

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
