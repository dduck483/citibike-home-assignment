select 
	bikeid,
	date_trunc('day', starttime),
	usertype,
	count(usertype)
from 
	trip_data 
group by 
	bikeid,
	starttime,
	usertype;