package com.craverush.controller;

import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Arrays;
import java.util.List;

@RestController
public class TestController {

    private final ApplicationContext context;

    public TestController(ApplicationContext context) {
        this.context = context;
    }

    @GetMapping("/test-beans")
    public List<String> testBeans() {
        return Arrays.asList(context.getBeanDefinitionNames());
    }
}
