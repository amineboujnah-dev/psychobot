from flask import Flask, jsonify, request
import json

#declared an empty variable for reassignment
response = ''

#creating the instance of our flask application
app = Flask(__name__)
myList=list()

#route to entertain our post and get request from flutter app
@app.route('/name', methods = ['GET', 'POST'])
def nameRoute():

    #fetching the global response variable to manipulate inside the function
    global response
    message =""

    #checking the request type we get from the app
    if(request.method == 'POST'):
        request_data = request.data #getting the response data
        request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
        name = request_data['name'] #assigning it to name
        myList.append(name)
        response = f'Hi {name}! I am psychobot' #re-assigning response with the name we got from the user
        myList.append(response)
        return "d" #to avoid a type error 
    else:
        return jsonify({'message': message,'name' : response, 'myList': myList ,'type' : len(myList)}) #sending data back to your frontend app

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)