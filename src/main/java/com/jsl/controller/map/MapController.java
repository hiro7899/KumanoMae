package com.jsl.controller.map;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.jsl.dto.map.MapMarkerDto;
import com.jsl.service.map.MapService;

@WebServlet("/map/*")
public class MapController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MapService mapService = new MapService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doAction(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doAction(request, response);
    }

    private void doAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();
        String page = null;

        if (path == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (path) {

        case "/view":
            page = "/WEB-INF/views/map/map.jsp";
            break;

        case "/markers":
            List<MapMarkerDto> markers = mapService.findAllMarkers();

            Gson gson = new Gson();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(markers));
            return;

        default:
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}