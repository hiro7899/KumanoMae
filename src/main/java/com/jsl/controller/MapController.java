package com.jsl.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.service.map.MapBoardListService;

@WebServlet("/map/*")
public class MapController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MapBoardListService mapBoardListService = new MapBoardListService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();

        if (path == null || "/".equals(path)) {
            mapBoardListService.doCommand(request, response);
            request.getRequestDispatcher("/WEB-INF/views/map/map.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}