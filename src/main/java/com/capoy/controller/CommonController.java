package com.capoy.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.capoy.domain.MemberVO;
import com.capoy.service.CommonService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
public class CommonController {
	
	private CommonService service;
	private PasswordEncoder pwEncoder;
	
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		
		log.info("access Denied : " + auth);
		
		model.addAttribute("msg", "Access Denied");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		
		log.info("error: " + error);
		log.info("logout: " + logout);
		
		if (error != null) {
			model.addAttribute("error", "Login Error, Check Your Account");
		}
		
		if (logout != null) {
			model.addAttribute("logout", "Logout!");
		}
		
	}
	
	@GetMapping("/customLogout")
	public void logoutGet() {
		
		log.info("custom logout");
	}
	
	@PostMapping("/customLogout")
	public void logoutPost() {
		
		log.info("post custom logout");
	}
	
	@GetMapping("/join")
	public void join() {
		
		log.info("join");
	}
	
	@PostMapping("/join")
	public String join(MemberVO memberVO, RedirectAttributes rttr) {
		
		log.info("memberVO : " + memberVO );
		
		memberVO.setUserpw(pwEncoder.encode(memberVO.getUserpw()));	
		
		if(service.join(memberVO)) {
			
			rttr.addFlashAttribute("result", "success");
			
		} else {
			
			rttr.addFlashAttribute("result", "fail");
		}
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/idCheck")
	@ResponseBody
	public String idCheck(String userid) {
		
		log.info("userId : " + userid);
		
		return service.idCheck(userid);	
	}
}
