package com.whetherapp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

@WebServlet("/getWhether")
public class GetWhetherServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String city = request.getParameter("city");
		String apiKey = "ba284a08695afe944964907bf6a0ff23";

		HttpSession session = request.getSession();

		if (city == null || city.isEmpty()) {
			session.setAttribute("msg", "Please, enter city name.");
			response.sendRedirect("index.jsp");
		} else {

			String urlLink = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + apiKey;

			URL url = new URL(urlLink);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");

			BufferedReader rd = new BufferedReader(new InputStreamReader(con.getInputStream()));
			StringBuilder result = new StringBuilder();

			String line;
			while ((line = rd.readLine()) != null) {
				result.append(line);
			}

			JSONObject json = new JSONObject(result.toString());
			System.out.println(json);
			
			String name = json.getString("name");
			JSONObject main = json.getJSONObject("main");
			
			int var = (int) main.getDouble("temp") ;
			int temp = var - 273;
			int humidity = main.getInt("humidity");
			int pressure = main.getInt("pressure");
			
			JSONObject wind = json.getJSONObject("wind");
			double speed = wind.getDouble("speed") * 3.6;
		
			JSONObject obj = json.getJSONArray("weather").getJSONObject(0) ;
			String status = obj.getString("main");
			
			String icon = obj.getString("icon");			
			String src = "https://openweathermap.org/img/w/" + icon + ".png";
			
			LocalDateTime now = LocalDateTime.now();
	        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
	        String formattedTime = now.format(formatter);
	        
	        session.setAttribute("city1", name);
	        session.setAttribute("temp", temp);
	        session.setAttribute("humidity", humidity);
	        session.setAttribute("pressure", pressure);
	        session.setAttribute("speed", speed);
	        session.setAttribute("status", status);
	        session.setAttribute("formattedTime", formattedTime);
	        session.setAttribute("src", src);
	        
	        response.sendRedirect("index.jsp");
		}
	}
}
