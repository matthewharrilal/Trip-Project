from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from bson.objectid import ObjectId
import bcrypt
import json
from CustomClass import JSONEncoder
from flask import jsonify
import pdb
from bson import BSON
from bson import json_util
from basicauth import decode
from bson.json_util import dumps

app = Flask(__name__)
client = MongoClient('mongodb://matthewharrilal:Latchman1@ds053160.mlab.com:53160/trip_planner_matthew')
database = app.db = client.trip_planner_matthew
rounds = app.bcrypt_rounds = 5
api = Api(app)


def authenticated_request(func):
    def wrapper(*args, **kwargs):
        auth = request.authorization
        auth_code = request.headers['authorization']
        email, password = decode(auth_code)
        if email is not None and password is not None:
            user_collection = database.posts
            user = user_collection.find_one({'email': email})
            if user is not None:
                encoded_password = password.encode('utf-8')
                if bcrypt.checkpw(encoded_password, user['password']):
                    return func(*args, **kwargs)
                else:
                    return ({'error': 'email or password is not correct'}, 401, None)
            else:
                return ({'error': 'could not find user in the database'}, 400, None)
        else:
            return ({'error': 'enter both email and password'}, 400, None)

    return wrapper

class User(Resource):
    def post(self):
        requested_json = request.json
        # We have a holder for the json requested data
        # We also need the data that the user essentially wants us to send back
        collection_of_posts = database.posts

        '''Now that we have the document we have to check the neccesary document and see if it has the neccesary crede
        ntials '''

        # So essentially we are going to send the passwords hashed to the database
        # First we have to declare how many times we want to run the encryption algorithm therefore we choose five
        # We have declared the number of rounds above

        # Essentially from there what we do is we take the password in the requested.json and then from there we can encode
        # password in plain text
        # But first we need the password from the json data
        user_password = requested_json.get('password')
        encoded_password = user_password.encode('utf-8')
        hashed = bcrypt.hashpw(encoded_password, bcrypt.gensalt(rounds))
        requested_json['password'] = hashed


        print(hashed)
        # So it is hashing the password therefore we have to find a way to insert this as the password instead of reg string as the password

        if 'email' in requested_json and 'password' in requested_json:
            collection_of_posts.insert_one(requested_json)
            requested_json.pop('password')

            print('The document has been implemented')
            # pdb.set_trace()
            return(requested_json, 201, None)

    @authenticated_request
    def get(self):
            # The function that ill be fetching our resources from the database
            # So we need access to the database and collection_

            collection_of_posts = app.db.posts
            auth = request.authorization

            # since then emails are unique we will use them as our fetching tool
            user_find = collection_of_posts.find_one({"email": auth.username})

            '''So essentially the error handling that we are doing now compared to the error
            handling we  have above is more solid because now we are essentially making our client which is password
            we are essentially making it we can only retrieve the results if the passwords math'''
            if auth.username is not None and auth.password is not None:
                user_find.pop('password')
                print('The user has successfully signed in')
                return(user_find, 200, None)
    @authenticated_request
    def put(self):
        # This function is what essentially edits the resources
        # This function is what essentially edits the resources

        '''So what we are essentially going to need for the function is
        the ability to edit resources therefore we need access to the collection'''
        collection_of_posts = database.posts
        # Now that we have the collection we can no edit the resources

        auth = request.authorization

        user_username = request.json.get('username')
        # We now have to locate the document with the specific problems
        user_query = collection_of_posts.find_one({'email': auth.username})
        # So now we essentially have access to all the documents with emails in them
        if user_query is not None:
            user_query['username'] = username
            collection_of_posts.save(user_query)
            print('The documents have been edited')
            return(user_query, 200, None)

    @authenticated_request
    def delete(self):
        # This is essentially the function to delete users and their accounts
        '''We are going to take the collection find the specific email and remove it
        using the remove method'''
        # pdb.set_trace()
        # Therefore first we have to find the document
        collection_of_posts = database.posts
        collection_of_trips = database.trips
        # Since we are deleting the user we have to delete the trips that correspond to the email

        # collection_of_trips = database.trips
        # Now let us fetch the email from the database as a unique identifier
        auth = request.authorization

        # Now that we have the email we can delete it using a general query
        user_query = collection_of_posts.find_one({'email': auth.username})
        trips_query = list(collection_of_trips.find({'email': auth.username}))

        # Now we can delete the resources
        if user_query is not None:
                collection_of_posts.remove(user_query)
                collection_of_trips.remove(json.loads(dumps(trips_query)))
                user_query.pop('password')
                print('The user and their trips have successfully been deleted')
                return(user_query, 204, None)

    @authenticated_request
    def patch(self):
        # So essentially this edits the whole doc as oppose to a singularity

        # So first we need to find the document through a unique identifier
        collection_of_posts = database.posts

        auth = request.authorization

        # Now that we have the collection we can now patch the resources
        # By finding the docs with their unique identifier
        user_email = request.args.get('email')

        user_username = request.json.get('email')
        user_username = request.json.get('username')
        user_password = request.json.get('password')
        edited_user_email = request.json.get('email')
        # So now that we have all the neccesary resources we can now patch the docs
        user_query = collection_of_posts.find_one({'email': auth.username})

        # Now we implement the error handling
        if user_query is not None:
            user_query['email'] = edited_user_email
            user_query['username'] = user_username
            user_query['password'] = user_password
            collection_of_posts.put(user_query)
            print('The existing document has succesfully been patched')
            return(user_query, 200, None)


class Trips(Resource):
    # This is essentially the same as the users class but for the Trips
    @authenticated_request
    def post(self):

        '''So essentially the plan for this function is going to be essentially to post resources but befroe that can even happen
        we have to enure that the user is logged in because then that defies the purpose of posting resources '''
        # This is essentially going to be able to post resource to our trip collection

        # Now we have to get access to the new collection that we are making
        collection_of_trips = database.trips

        # We also need access to the other collection and to do that we need to make a reference
        collection_of_posts = database.posts

        # Now that we have access to the collection we can begin to post the resources
        requested_json = request.json

        # So now we need access to the password and the email in the parmaeters that the network request consists of
        auth = request.authorization

        encoded_password = auth.password.encode('utf-8')

        user_account_find = collection_of_posts.find_one({'email': auth.username})

        '''So essentially the plan is for us to encode the data and what we have to do is that we have to
        even when the user is posting their trips even though we are not passing in the password what we can essentially do
        is that we can still use that we are making a get request'''

        if bcrypt.checkpw(encoded_password, user_account_find['password']):
            collection_of_trips.insert_one(requested_json)
            print('The document does have an email address in it')
            return(requested_json, 201, None)

    @authenticated_request
    def get(self):
        # This function essentially fetches the resources
        # Let us get access to the collection first
        collection_of_trips = database.trips
        collection_of_posts = database.posts
        # Now that we have the collection we can fetch resources by email

        auth = request.authorization
        encoded_password = auth.password.encode('utf-8')

        # Now that we have the raw value we have to actually see that
        # it is stored within our database
        email_find = list(collection_of_trips.find({'email': auth.username}))
        print(email_find)
        user_password_find = collection_of_posts.find_one({'email': auth.username})


        # json_email_find = dumps(email_find)
        if bcrypt.checkpw(encoded_password, user_password_find['password']):
            print("The user succesfully fetched their trips")
            # print("The elements in the document array are : %s" %(documents_array))
            return(json.loads(dumps(email_find)), 200, None)
        # else:
        #     print('The trips can not be found')
        #     return(None, 401, None)

    @authenticated_request
    def delete(self):
        # This function will essentially delete resources
        # First we need access to the collection
        collection_of_trips = database.trips
        collection_of_posts = database.posts


        # Then we have to find which document in our database that we have to delete
        auth = request.authorization

        encoded_password = auth.password.encode('utf-8')
        trips_destination = request.args.get('destination')
        # Now that we have the email we have to find the document in our database
        trips_email = collection_of_trips.find_one({'email': auth.username})
        user_account_find = collection_of_posts.find_one({'email': auth.username})
        # Essentially we are still left with the problem that we dont have the specific trip that the user is trying
        # to delete
        removed_destination = collection_of_trips.find_one({'destination': trips_destination})

        # Now that we are in the proccess of finding it we have to confirm if the document actually exists
        if trips_email is not None and bcrypt.checkpw(encoded_password, user_account_find['password']) and removed_destination is not None:
            removed_trip = collection_of_trips.remove(removed_destination)
            print('The trip has been removed')
            return(removed_trip, 204, None)

    @authenticated_request
    def put(self):
        '''Essentially what this function will do is that it will allow us to be able to edit resources in our document
        however since when a put request is made all the data gets sent back with it therefore what we have to do is that we
        have to whenever the user makes a put request make sure they are editing everything about the trip except their identifier
        which is the email'''

        # first things first we have to get access to the collection
        collection_of_trips = database.trips

        # We are also going to need access to our other collection therefore a reference is in order
        collection_of_posts = database.posts
        # So now that we have the collection we can now specify what the user has to do make a succesfull put request

        # First we have to find the document they want to edit
        auth = request.authorization
        trips_query = collection_of_trips.find_one({'email': auth.username})
        specific_trip = request.args.get("destination")
        # specific_trip_query = collection_of_trips.find_one({'destination': specific_trip})

        encoded_password = auth.password.encode('utf-8')

        user_account_find = collection_of_posts.find_one({'email': auth.username})

        new_destination = request.json['tripsList'][0]['destination']
        new_start_date = request.json['tripsList'][0]['start_date']
        new_end_date = request.json['tripsList'][0]['end_date']
        new_waypoint_destination = request.json['tripsList'][0]['waypoint']['waypoint_destination']
        if trips_query is not None and bcrypt.checkpw(encoded_password, user_account_find['password']):
            # So essentially this is the part where we save the changes to our database
                trips_query['tripsList'][0]['destination'] = new_destination
                trips_query['tripsList'][0]['start_date'] = new_start_date
                trips_query['tripsList'][0]['end_date'] = new_end_date
                trips_query['tripsList'][0]['waypoint']['waypoint_destination'] = new_waypoint_destination
                collection_of_trips.save(trips_query)
                print('The changes to the trip has been saved')
                return(trips_query, 200, None)
    # def patch(self):
        # This is essentially the function where we patch resources
        # First things first we need access to the collection


# This is essentially our decorator and what we are doing here is that we are basically self contained blocks of code that we can pass around



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
