The command "curl" is used to send requests to the server.

Setting username:
ex: AUTHORIZATION: arb
arb is the username

Posting event format:
ex: {"title": "another event","date":"0404","time":"13:45","zipcode":"06405"}
-title: title of event
-date: MMDD
-time: 13:45 (Military time only)
-zipcode: 06405

deletes the event {"title":"new"}
ex: -X DELETE -d '{"title":"new"}' 


Example commands:


curl http://localhost:4567/calendar -H "AUTHORIZATION: arb"

curl -X POST -d'{"title": "another event","date":"0404","time":"13:45","zipcode":"06405"}' http://localhost:4567/calendar -H "AUTHORIZATION: arb"

curl -X DELETE -d '{"title":"new"}' http://localhost:4567/calendar -H "AUTHORIZATION: arb"


Once the herokuapp dyno is working these commands should work as well.

curl -X POST -d'{"title": "another event","date":"0404","time":"13:45","zipcode":"06405"}' http://tiy-event-planner.herokuapp.com/calendar -H "AUTHORIZATION: arb"

curl -X DELETE -d '{"title":"new"}' http://tiy-event-planner.herokuapp.com/calendar -H "AUTHORIZATION: arb"