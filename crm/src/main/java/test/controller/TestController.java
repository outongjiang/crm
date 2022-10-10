package test.controller;
import com.alibaba.druid.support.json.JSONUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.util.JSONPObject;
import net.sf.json.JSON;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import person.otj.crm.commons.contants.Contants;
import person.otj.crm.commons.domain.ReturnObject;
import person.otj.crm.commons.utils.DateUtils;
import person.otj.crm.commons.utils.ImageBase64Utils;
import person.otj.crm.commons.utils.UUIDUtils;
import person.otj.crm.settings.model.User;
import person.otj.crm.workbench.mapper.ActivitiesMapper;
import person.otj.crm.workbench.mapper.ClueMapper;
import person.otj.crm.workbench.model.Activities;
import person.otj.crm.workbench.model.Clue;
import person.otj.crm.workbench.model.Customer;
import person.otj.crm.workbench.service.ActivityService;
import person.otj.crm.workbench.service.ClueService;
import person.otj.crm.workbench.service.CustomerService;
import test.model.IdentityParam;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.DataBufferUShort;
import java.io.*;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class TestController {

    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private CustomerService customerService;
    @ResponseBody
    @RequestMapping("/batchInsert")
    public String batchInsert(){
        Activities activities=new Activities();
        activities.setId(UUIDUtils.getUUID());
        activities.setCost("4000");
        activities.setCreateTime(DateUtils.formateDateTime(new Date()));
        activities.setCreateBy("06f5fc056eac41558a964f96daa7f27c");
        activities.setName("活动"+String.valueOf((int)(Math.random()*100)));
        activities.setOwner("40f6cdea0bd34aceb77492a1656d9fb3");
        activities.setDescription("这是活动"+activities.getName()+"的描述");
        activities.setStartDate(DateUtils.formateDateTimeSimple(new Date()));
        Date date=new Date();
        int rnum=(int)(Math.random()*10)-7;
        DateUtils.setMonth(date,date.getMonth()+1+(rnum<0?1:rnum));
        date.setDate((int)(Math.random()*10)*2);
        activities.setEndDate(DateUtils.formateDateTimeSimple(date));
        activityService.saveCreateActivity(activities);
        return "";
    }

    @RequestMapping("/test")
    public String toLogin(){

        return "test/test";
    }

    @RequestMapping("/test2")
    public String test2(HttpSession session, HttpServletResponse response){
        System.out.println(session.getAttribute("role"));
        Cookie cookie=new Cookie("c","c111");
        response.addCookie(cookie);
        return "test/test2";
    }

    @RequestMapping("/test3")
    @ResponseBody
    public String test3(HttpSession session){
        User user =new User();
        user.setName("欧桐江");
        session.setAttribute("role",user);
        return "11";
    }

    @RequestMapping("/test01")
    public String test01(){

        return "test01";
    }


    @RequestMapping("/test02")
    public String test02(){

        return "test02";
    }


    @RequestMapping("/fileDownLoadTest")
    public String fileDownLoadTest(){

        return "fileDownLoadTest";
    }

    @RequestMapping("/test0101")
    @ResponseBody
    public String test0101(HttpServletRequest request) throws IOException {

        String realPath = request.getServletContext().getRealPath("/");

        System.out.println(realPath);

        realPath+="ooo.txt";

        File file=new File(realPath);

        BufferedReader reader=new BufferedReader(new FileReader(realPath));

        System.out.println(reader.readLine());
        return "test0101";
    }


    @RequestMapping("/test03")
    public String test03(){
        return "test03";
    }

    @RequestMapping("/testBase64")
    @ResponseBody
    public String  testBase64(HttpServletRequest request){
        String imageBase64code = ImageBase64Utils.getImageBase64(request,"sfzzm.jpg");
        RestTemplate restTemplate=new RestTemplate();
        String url="https://way.jd.com/wintone/IDCard_base64?typeId=2&appkey=88dd6a34ecd37be17cd791ad8f56844f";
//        HttpHeaders headers = new HttpHeaders();
//        LinkedMultiValueMap<String, Object> params= new LinkedMultiValueMap<>();
//        params.add("img", imageBase64code);
//        HttpEntity<MultiValueMap<String, Object>> request1 = new HttpEntity<MultiValueMap<String, Object>>(params,headers);


        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        ObjectMapper objectMapper = new ObjectMapper();
        ObjectNode params = objectMapper.createObjectNode();
        params.put("img", imageBase64code);
        HttpEntity<String>  request1 = new HttpEntity<String>(params.toString(),headers);
        return restTemplate.postForEntity(url,request1,String.class).getBody();


    }


    @RequestMapping(value = "/weatherForcast")
    @ResponseBody
    public Object  weatherForcast(HttpServletRequest req){
        String imageBase64code = ImageBase64Utils.getImageBase64(req,"sfzzm.jpg");
        RestTemplate restTemplate=new RestTemplate();
        Map body=new HashMap();
        body.put("img",imageBase64code);
        String jsonData=JSONUtils.toJSONString(body);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String>request=new HttpEntity<>(jsonData,headers);
        MultiValueMap<String,String>map=new LinkedMultiValueMap<>();
        map.add("typeId","2");
        map.add("appkey","88dd6a34ecd37be17cd791ad8f56844f");
        UriComponentsBuilder builder=UriComponentsBuilder.fromHttpUrl("https://way.jd.com/wintone/IDCard_base64").queryParams(map);
//        IdentityParam identityParam=new IdentityParam();
//        identityParam.setAppkey("88dd6a34ecd37be17cd791ad8f56844f");
//        identityParam.setArea("丽江");
        ResponseEntity<JSONObject> jsonObjectResponseEntity = restTemplate.postForEntity(builder.toUriString(), request, JSONObject.class);
        System.out.println(jsonObjectResponseEntity);
        System.out.println(jsonObjectResponseEntity.getBody());
        return "";
    }

    @RequestMapping("/testMapParam")
    @ResponseBody
    public String  testMapParam(@RequestParam Map<String,Object>map){
        System.out.println(map.get("name"));
        System.out.println(map.get("value"));
        return "";
    }

    @RequestMapping("/test/saveCreateClue.do")
    @ResponseBody
    public Object saveCreateClue(HttpSession session, HttpServletRequest request){
        User user= (User) session.getAttribute(Contants.SESSION_USER);
        ReturnObject returnObject=new ReturnObject();
        Clue clue=new Clue();
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateTime(DateUtils.formateDateTime(new Date()));
        clue.setCreateBy(user.getId());
        clue.setFullname("线索"+(int)(Math.random()*100));
        clue.setAppellation("176039d2a90e4b1a81c5ab8707268636");
        clue.setOwner("06f5fc056eac41558a964f96daa7f27c");
        clue.setCompany(Math.random()>0.5?"腾讯":"字节跳动");
        clue.setJob(Math.random()>0.5?"高级":"中级"+"java工程师");
        clue.setEmail("434234.com");
        clue.setPhone("434435453");
        clue.setWebsite("sadfdsaf.com");
        clue.setMphone("424243242");
        clue.setState("310e6a49bd8a4962b3f95a1d92eb76f4");
        clue.setSource("fb65d7fdb9c6483db02713e6bc05dd19");
        clue.setDescription("描述"+(int)(Math.random()*100));
        clue.setContactSummary("纪要"+(int)(Math.random()*100));
        clue.setNextContactTime(DateUtils.formateDateTimeSimple(new Date()));
        clue.setAddress(Math.random()>0.5?"嵩山":"华山");
        clueService.saveCreateClue(clue);
        return "";
    }


    @RequestMapping("/test/saveCreateCustomer.do")
    @ResponseBody
    public Object saveCreateCustomer(HttpSession session, HttpServletRequest request){
        User user= (User) session.getAttribute(Contants.SESSION_USER);
        Customer customer=new Customer();
        customer.setCreateTime(DateUtils.formateDateTime(new Date()));
        customer.setCreateBy(user.getId());
        customer.setOwner(user.getId());
        customer.setName(Math.random()>0.5?"百度":"小米");
        customer.setId(UUIDUtils.getUUID());
        customer.setWebsite("dadas.com");
        customer.setPhone("1343443534");
        customer.setDescription("这是一个描述"+(int)(Math.random()*100));
        customer.setNextContactTime(DateUtils.formateDateTimeSimple(new Date()));
        customer.setContactSummary("联系纪要"+(int)(Math.random()*100));
        customer.setAddress("广东");
        customerService.saveCreateCustomer(customer);
        return "";
    }

}

