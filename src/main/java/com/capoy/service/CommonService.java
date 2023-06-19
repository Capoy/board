package com.capoy.service;

import com.capoy.domain.MemberVO;

public interface CommonService {
	
	public String idCheck(String userid);
	
	public boolean join(MemberVO memberVO);

}
