package com.jsl.util;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

@WebFilter(urlPatterns = {
		"", "/index", "/", "/map", "/map/*", "/board/report", 
		})
public class GoogleMapsFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        String googleMapsApiKey =
                System.getenv("GOOGLE_MAPS_API_KEY");

        request.setAttribute("googleMapsApiKey", googleMapsApiKey);

        chain.doFilter(request, response);
    }
}