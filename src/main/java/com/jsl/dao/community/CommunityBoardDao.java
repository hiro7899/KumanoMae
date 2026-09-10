package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.sql.community.CommunityBoardSql;
import com.jsl.util.DBManager;

public class CommunityBoardDao {

	public List<CommunityBoardDto> selectList(String category) {

		StringBuilder sql = new StringBuilder(CommunityBoardSql.SELECT_LIST);

		if (category != null && !category.isEmpty()) {
			sql.append(" AND cb.CATEGORY = ?");
		}

		sql.append(" ORDER BY cb.REG_DATE DESC");

		List<CommunityBoardDto> list = new ArrayList<>();

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			if (category != null && !category.isEmpty()) {
				pstmt.setString(1, category);
			}

			try (ResultSet rs = pstmt.executeQuery()) {

				while (rs.next()) {
					CommunityBoardDto dto = new CommunityBoardDto();

					dto.setCBoardId(rs.getLong("C_BOARD_ID"));
					dto.setMemberId(rs.getLong("MEMBER_ID"));
					dto.setCategory(rs.getString("CATEGORY"));
					dto.setTitle(rs.getString("TITLE"));
					dto.setGearName(rs.getString("GEAR_NAME"));
					dto.setViewCnt(rs.getInt("VIEW_CNT"));
					dto.setLikeCnt(rs.getInt("LIKE_CNT"));
					dto.setWriterName(rs.getString("WRITER_NAME"));
					dto.setCommentCnt(rs.getInt("COMMENT_CNT"));

					if (rs.getTimestamp("REG_DATE") != null) {
						dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
					}

					list.add(dto);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public CommunityBoardDto selectById(Long cBoardId) {

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.SELECT_BY_ID)) {

			pstmt.setLong(1, cBoardId);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (!rs.next()) {
					return null;
				}

				CommunityBoardDto dto = new CommunityBoardDto();

				dto.setCBoardId(rs.getLong("C_BOARD_ID"));
				dto.setMemberId(rs.getLong("MEMBER_ID"));
				dto.setCategory(rs.getString("CATEGORY"));
				dto.setTitle(rs.getString("TITLE"));
				dto.setContent(rs.getString("CONTENT"));
				dto.setGearName(rs.getString("GEAR_NAME"));
				dto.setViewCnt(rs.getInt("VIEW_CNT"));
				dto.setLikeCnt(rs.getInt("LIKE_CNT"));
				dto.setStatus(rs.getString("STATUS"));
				dto.setWriterName(rs.getString("WRITER_NAME"));
				dto.setCommentCnt(rs.getInt("COMMENT_CNT"));

				if (rs.getTimestamp("REG_DATE") != null) {
					dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
				}

				if (rs.getTimestamp("MOD_DATE") != null) {
					dto.setModDate(rs.getTimestamp("MOD_DATE").toLocalDateTime());
				}

				return dto;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public Long insertBoard(Connection conn, CommunityBoardDto dto) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.INSERT_BOARD,
				new String[] { "C_BOARD_ID" })) {

			pstmt.setLong(1, dto.getMemberId());
			pstmt.setString(2, dto.getCategory());
			pstmt.setString(3, dto.getTitle());
			pstmt.setString(4, dto.getContent());
			pstmt.setString(5, dto.getGearName());

			pstmt.executeUpdate();

			try (ResultSet keys = pstmt.getGeneratedKeys()) {
				if (keys.next()) {
					return keys.getLong(1);
				}
			}

			throw new SQLException("C_BOARD_ID 채번에 실패했습니다.");
		}
	}

	public int updateBoard(Connection conn, CommunityBoardDto dto) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.UPDATE_BOARD)) {

			pstmt.setString(1, dto.getCategory());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getGearName());
			pstmt.setLong(5, dto.getCBoardId());

			return pstmt.executeUpdate();
		}
	}

	/** 소프트 삭제 - 파일은 지우지 않음 */
	public int updateStatus(Connection conn, Long cBoardId, String status) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.UPDATE_STATUS)) {

			pstmt.setString(1, status);
			pstmt.setLong(2, cBoardId);

			return pstmt.executeUpdate();
		}
	}

	public int increaseViewCnt(Long cBoardId) {

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.INCREASE_VIEW_CNT)) {

			pstmt.setLong(1, cBoardId);

			return pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	public Long findWriterId(Long cBoardId) {

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.SELECT_WRITER_ID)) {

			pstmt.setLong(1, cBoardId);

			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() ? rs.getLong("MEMBER_ID") : null;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public String findStatus(Connection conn, Long cBoardId) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.SELECT_STATUS)) {

			pstmt.setLong(1, cBoardId);

			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next() ? rs.getString("STATUS") : null;
			}
		}
	}

	public int updateLikeCnt(Connection conn, Long cBoardId, int delta) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.UPDATE_LIKE_CNT)) {

			pstmt.setInt(1, delta);
			pstmt.setLong(2, cBoardId);

			return pstmt.executeUpdate();
		}
	}

	public int countActive() {

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.COUNT_ACTIVE);
				ResultSet rs = pstmt.executeQuery()) {

			return rs.next() ? rs.getInt(1) : 0;

		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	/** 관리자용 - 상태(Y/N) 무관하게 전체 조회 */
	public List<CommunityBoardDto> selectAllForAdmin(String statusFilter) {

		StringBuilder sql = new StringBuilder(CommunityBoardSql.SELECT_ALL_FOR_ADMIN);

		boolean filter = statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter);

		if (filter) {
			sql.append(" WHERE STATUS = ?");
		}

		sql.append(" ORDER BY REG_DATE DESC");

		List<CommunityBoardDto> list = new ArrayList<>();

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

			if (filter) {
				pstmt.setString(1, statusFilter);
			}

			try (ResultSet rs = pstmt.executeQuery()) {

				while (rs.next()) {
					CommunityBoardDto dto = new CommunityBoardDto();

					dto.setCBoardId(rs.getLong("C_BOARD_ID"));
					dto.setMemberId(rs.getLong("MEMBER_ID"));
					dto.setCategory(rs.getString("CATEGORY"));
					dto.setTitle(rs.getString("TITLE"));
					dto.setGearName(rs.getString("GEAR_NAME"));
					dto.setViewCnt(rs.getInt("VIEW_CNT"));
					dto.setLikeCnt(rs.getInt("LIKE_CNT"));
					dto.setStatus(rs.getString("STATUS"));

					if (rs.getTimestamp("REG_DATE") != null) {
						dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
					}

					list.add(dto);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	/** 관리자용 - STATUS 무관하게 단건 조회 */
	public CommunityBoardDto selectByIdForAdmin(Long cBoardId) {

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.SELECT_BY_ID_FOR_ADMIN)) {

			pstmt.setLong(1, cBoardId);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (!rs.next()) {
					return null;
				}

				CommunityBoardDto dto = new CommunityBoardDto();

				dto.setCBoardId(rs.getLong("C_BOARD_ID"));
				dto.setMemberId(rs.getLong("MEMBER_ID"));
				dto.setCategory(rs.getString("CATEGORY"));
				dto.setTitle(rs.getString("TITLE"));
				dto.setContent(rs.getString("CONTENT"));
				dto.setGearName(rs.getString("GEAR_NAME"));
				dto.setViewCnt(rs.getInt("VIEW_CNT"));
				dto.setLikeCnt(rs.getInt("LIKE_CNT"));
				dto.setStatus(rs.getString("STATUS"));

				if (rs.getTimestamp("REG_DATE") != null) {
					dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
				}

				if (rs.getTimestamp("MOD_DATE") != null) {
					dto.setModDate(rs.getTimestamp("MOD_DATE").toLocalDateTime());
				}

				return dto;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/** 관리자 완전삭제용 */
	public int deletePhysically(Connection conn, Long cBoardId) throws SQLException {

		try (PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.DELETE_PHYSICALLY)) {

			pstmt.setLong(1, cBoardId);

			return pstmt.executeUpdate();
		}
	}

	public List<CommunityBoardDto> selectRecentActive(int limit) {

		List<CommunityBoardDto> list = new ArrayList<>();

		try (Connection conn = DBManager.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(CommunityBoardSql.SELECT_RECENT_ACTIVE)) {

			pstmt.setInt(1, limit);

			try (ResultSet rs = pstmt.executeQuery()) {

				while (rs.next()) {
					CommunityBoardDto dto = new CommunityBoardDto();

					dto.setCBoardId(rs.getLong("C_BOARD_ID"));
					dto.setMemberId(rs.getLong("MEMBER_ID"));
					dto.setCategory(rs.getString("CATEGORY"));
					dto.setTitle(rs.getString("TITLE"));
					dto.setGearName(rs.getString("GEAR_NAME"));
					dto.setViewCnt(rs.getInt("VIEW_CNT"));
					dto.setLikeCnt(rs.getInt("LIKE_CNT"));
					dto.setWriterName(rs.getString("WRITER_NAME"));
					dto.setCommentCnt(rs.getInt("COMMENT_CNT"));

					if (rs.getTimestamp("REG_DATE") != null) {
						dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
					}

					list.add(dto);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}