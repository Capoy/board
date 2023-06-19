package com.capoy.mapper;

import com.capoy.domain.AuthVO;
import com.capoy.domain.MemberVO;

public interface MemberMapper {

	public MemberVO read(String userid);
	
	public String checkByUserId(String userid);
	
	public int insert(MemberVO memberVO);
	
	public void insertAuth(AuthVO authVO);
}
