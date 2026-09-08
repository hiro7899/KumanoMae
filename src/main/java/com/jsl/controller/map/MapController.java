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

        // /map 또는 /map/ 요청
        if (path == null || "/".equals(path)) {
            page = "/WEB-INF/views/map/map.jsp";
        } else {

            // /map/markers 등
            switch (path) {

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
        }

        // JSP 화면 출력
        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}