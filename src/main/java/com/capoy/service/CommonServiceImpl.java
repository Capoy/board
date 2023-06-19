package com.capoy.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.capoy.domain.MemberVO;
import com.capoy.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class CommonServiceImpl implements CommonService {
	
	private MemberMapper mapper;
	
	@Override
	public String idCheck(String userid) {
		
		return mapper.checkByUserId(userid);
	}
	
	@Override
	public boolean join(MemberVO memberVO) {
		
		boolean joinResult = mapper.insert(memberVO) == 1;
		
		if( joinResult && (memberVO.getAuthList() != null && memberVO.getAuthList().size() > 0)) {
			
			memberVO.getAuthList().forEach(auth -> {
				
				mapper.insertAuth(auth);
			});
		}
		
		return joinResult;
	}

}
