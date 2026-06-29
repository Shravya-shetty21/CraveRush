package com.craverush;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class CraveRushApplication extends SpringBootServletInitializer {

    @Override
    protected org.springframework.boot.builder.SpringApplicationBuilder configure(org.springframework.boot.builder.SpringApplicationBuilder application) {
        return application.sources(CraveRushApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(CraveRushApplication.class, args);
    }
}
