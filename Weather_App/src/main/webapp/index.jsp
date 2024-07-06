<!DOCTYPE html>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="components/style.jsp"%>

</head>
<body>
	<div class="center">
		<h1 class="text-center mt-3" style="color: black;">Weather App</h1>
		<form action="getWhether" method="post"
			class="d-flex align-items-center mt-4">
			<input type="text" name="city" class="form-control custom-input"
				placeholder="Enter city">
			<button type="submit" class="btn custom-btn ms-1">
				<i class="fas fa-search"></i>
			</button>
		</form>
		</div>		
		<% 
		int i = 0;
		if(session.getAttribute("status") == null){
			
			LocalDateTime now = LocalDateTime.now();
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
	        String formattedTime = now.format(formatter);
			
			String urlLink = "https://api.openweathermap.org/data/2.5/weather?q=solapur&appid=ba284a08695afe944964907bf6a0ff23";
			URL url = new URL(urlLink);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			
			BufferedReader rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
			StringBuilder result = new StringBuilder();
			
			String line;
			while((line = rd.readLine()) != null){
				
				result.append(line);
			}
			
			JSONObject json = new JSONObject(result.toString());
			JSONObject main = json.getJSONObject("main");
			
			int temp = (int) main.getDouble("temp") - 273;
			int humidity = main.getInt("humidity");
			int pressure = main.getInt("pressure");
			
			JSONObject wind = json.getJSONObject("wind");
			double speed = wind.getDouble("speed") * 3.6;
		
			JSONObject obj = json.getJSONArray("weather").getJSONObject(0) ;
			String status = obj.getString("main");
			
			String icon = obj.getString("icon");			
			String src = "https://openweathermap.org/img/w/" + icon + ".png";
			
		%>

<div class="row d-flex justify-content-center py-5" style="margin-top: 90px;">
    <div class="col-md-8 col-lg-6 col-xl-5">
        <div class="card text-body weather-card" style="border-radius: 35px;">
            <div class="card-body p-4">
                <div class="d-flex">
                    <h6 class="flex-grow-1" style="color: black;"><%= json.getString("name") %></h6>
                    <h6 style="color: black;"><%=formattedTime %></h6>
                </div>
                <div class="d-flex flex-column text-center  mt-5 mb-4">
                    <h6 class="display-4 mb-0 font-weight-bold" style="color: black;"><%=temp %>°C</h6>
                    <span class="small weather-description" style="color: black;"><%=status %></span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1 weather-details" style="font-size: 1rem;">
                        <div>
                            <i class="fas fa-wind fa-fw weather-icon " style="color: black;"></i>
                            <span class="ms-1 "> <%=String.format("%.1f", speed) %> km/h </span>
                        </div>
                        <div>
                            <i class="fas fa-tint fa-fw weather-icon " style="color: black;"></i>
                            <span class="ms-1 "> <%=humidity %>% </span>
                        </div>
                    <div>
                            <i class="fa-solid fa-arrows-down-to-line text-black"></i>
                            <span class="ms-1 "> <%= pressure %>hPa </span>
                        </div>
                    </div>
                    <div>
                        <img src=<%= src %> width="100px">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<% i++; 
} 
else{
%>
<div class="row d-flex justify-content-center py-5" style="margin-top: 90px;">
    <div class="col-md-8 col-lg-6 col-xl-5">
        <div class="card text-body weather-card" style="border-radius: 35px;">
            <div class="card-body p-4">
                <div class="d-flex">
                    <h6 class="flex-grow-1" style="color: black;"><%= session.getAttribute("city1") %></h6>
                    <h6 style="color: black;"><%= session.getAttribute("formattedTime")%></h6>
                </div>
                <div class="d-flex flex-column text-center  mt-5 mb-4">
                    <h6 class="display-4 mb-0 font-weight-bold" style="color: black;"><%= session.getAttribute("temp")%>°C</h6>
                    <span class="small weather-description" style="color: black;"><%= session.getAttribute("status")%></span>
                </div>
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1 weather-details" style="font-size: 1rem;">
                        <div>
                            <i class="fas fa-wind fa-fw weather-icon " style="color: black;"></i>
                            <span class="ms-1 "> <%=String.format("%.1f", session.getAttribute("speed")) %> km/h </span>
                        </div>
                        <div>
                            <i class="fas fa-tint fa-fw weather-icon " style="color: black;"></i>
                            <span class="ms-1 "> <%= session.getAttribute("humidity")%>% </span>
                        </div>
                    <div>
                            <i class="fa-solid fa-arrows-down-to-line text-black"></i>
                            <span class="ms-1 "> <%=  session.getAttribute("pressure")%> hPa </span>
                        </div>
                    </div>
                    <div>
                        <img src=<%= session.getAttribute("src")%> width="100px">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%} %>
</body>
</html>