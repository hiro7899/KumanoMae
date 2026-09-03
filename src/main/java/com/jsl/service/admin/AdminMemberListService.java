package com.jsl.service.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.member.MemberDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;

public class AdminMemberListService implements Command {

    private final MemberDao memberDao = new MemberDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<MemberDto> memberList = memberDao.selectAllMembers();
        request.setAttribute("memberList", memberList);
    }
}